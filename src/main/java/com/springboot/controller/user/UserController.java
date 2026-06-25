package com.springboot.controller.user;
 
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.springboot.model.Ceremony;
import com.springboot.model.Item;
import com.springboot.model.Member;
import com.springboot.model.Review;
import com.springboot.service.BookingService;
import com.springboot.service.CeremonyService;
import com.springboot.service.MemberService;
import com.springboot.service.ReviewService;

 
@Controller
public class UserController {
 
    @Autowired
    private MemberService memberService; 
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private BookingService bookingService;
    
    @Autowired
    private CeremonyService ceremonyService;
 
    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("member", new Member()); 
        return "register";
    }
 
    @PostMapping("/saveMember")
    public String saveMember(@ModelAttribute Member member) {
        memberService.saveMember(member); 
        return "redirect:/loginMember?successRegister"; // เปลี่ยนให้ไปหน้า Login หลังสมัครเสร็จ
    }
    
    //แก้ตรงนี้ ล่าสุด
    @GetMapping("/home")
    public String home(Model model) {
        // 1. ดึงเฉพาะ 2 รีวิวล่าสุดจากฐานข้อมูล (เรียงจากใหม่ไปเก่า)
        List<Review> top2Reviews = reviewService.getTop2RecentReviews();
        model.addAttribute("reviews", top2Reviews);

        // 2. ดึงรีวิวทั้งหมดเพื่อใช้คำนวณคะแนนเฉลี่ยเท่านั้น
        List<Review> allReviews = reviewService.getAllReviews();
        model.addAttribute("avgRating1", calculateAverage(allReviews, 1));
        model.addAttribute("avgRating2", calculateAverage(allReviews, 2));

        // 3. ส่วนของปฏิทินงาน
        List<String> bookedDates = bookingService.getAllBookings().stream()
            .filter(b -> b.getBookingStatus() != null && (
                "Approved".equals(b.getBookingStatus()) ||
                "Confirmed".equals(b.getBookingStatus()) ||
                "Completed".equals(b.getBookingStatus())))
            .map(b -> { 
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                return b.getEventDate() != null ? sdf.format(b.getEventDate()) : ""; 
            })
            .filter(date -> !date.isEmpty())
            .collect(Collectors.toList());
        
        model.addAttribute("bookedDates", bookedDates);

        return "home";
    }
    
    //แก้ ในส่วน ของ view แำพำทนืั ล่าสุด
    @GetMapping("/ceremony/detail/{id}")
    public String showCeremonyDetail(@PathVariable int id, Model model) {
        Ceremony ceremony = ceremonyService.getCeremonyById(id);
        if (ceremony == null) return "redirect:/home";

        List<Item> equipmentList = new ArrayList<>();
        List<Item> serviceList = new ArrayList<>();
        List<Item> pintoSets = new ArrayList<>();
        List<Item> pintoMenus = new ArrayList<>();
        
        // 🔥 เพิ่ม List สำหรับสังฆทาน
        List<Item> sanghatanSets = new ArrayList<>(); 

        for (Item item : ceremony.getItems()) {
            String typeName = item.getItemType().getItemTypeName();
            
            if (typeName.contains("อุปกรณ์")) {
                equipmentList.add(item);
            } else if (typeName.contains("ปิ่นโต")) {
                if (item.getItemName().contains("ชุด")) {
                    pintoSets.add(item);
                } else {
                    pintoMenus.add(item);
                }
            } else if (typeName.contains("บริการ")) {
                serviceList.add(item);
            } 
            // 🔥 ตรวจสอบกลุ่มสังฆทาน (สมมติว่า typeName มีคำว่า "สังฆทาน")
            else if (typeName.contains("สังฆทาน")) {
                sanghatanSets.add(item);
            }
        }

        model.addAttribute("ceremony", ceremony);
        model.addAttribute("equipments", equipmentList);
        model.addAttribute("pintoSets", pintoSets); 
        model.addAttribute("pintoMenus", pintoMenus);
        model.addAttribute("services", serviceList);
        
        // 🔥 ส่ง sanghatanSets ไปที่ JSP
        model.addAttribute("sanghatanSets", sanghatanSets); 

        return "ceremonyDetail";
    }
    
    private double calculateAverage(List<Review> reviews, int ceremonyId) {
        return reviews.stream()
            .filter(r -> r.getBookingForm() != null && 
                         r.getBookingForm().getCeremony() != null && 
                         r.getBookingForm().getCeremony().getCeremonyId() == ceremonyId)
            .mapToDouble(Review::getRating)
            .average()
            .orElse(0.0);
    }
    
}

