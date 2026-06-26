package com.springboot.controller.member;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.model.BookingForm;
import com.springboot.model.Ceremony;
import com.springboot.model.Item;
import com.springboot.model.Member;
import com.springboot.model.QuestionsDetail;
import com.springboot.service.BookingService;
import com.springboot.service.CeremonyService;
import com.springboot.service.ItemService;
import com.springboot.service.QuestionsService;
import com.springboot.service.ReviewService;

import jakarta.servlet.http.HttpSession;

@Controller
public class BookingFormController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private QuestionsService questionsService;
    
    @Autowired
    private ItemService itemService;
    
    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private CeremonyService ceremonyService;
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }
    
    // --- แก้ไขเมธอด showBookingForm ---
    @GetMapping("/booking")
    public String showBookingForm(Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember?error=pleaseLogin";

        List<QuestionsDetail> questions = questionsService.getQuestionsByCeremony(1);
        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        
        // ปรับชื่อตัวแปรให้เป็น sanghatharnItems
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        model.addAttribute("booking", new BookingForm());
        model.addAttribute("questions", questions);
        model.addAttribute("pintoItems", pintoItems); 
        model.addAttribute("sanghatharnItems", sanghatharnItems); // ชื่อต้องตรงกัน

        return "fillBookingForm";
    }

    // --- แก้ไขเมธอด showBookingForm2 ---
    @GetMapping("/booking2")
    public String showBookingForm2(Model model, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember?error=pleaseLogin";

        List<QuestionsDetail> questions = questionsService.getQuestionsByCeremony(2);
        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        
        // ปรับชื่อตัวแปรให้เป็น sanghatharnItems
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        model.addAttribute("booking", new BookingForm());
        model.addAttribute("questions", questions);
        model.addAttribute("pintoItems", pintoItems); 
        model.addAttribute("sanghatharnItems", sanghatharnItems); // ชื่อต้องตรงกัน

        return "fillBookingForm2";
    }

    /*===========แก้===========*/
    @PostMapping("/saveBooking")
    public String saveBooking(@ModelAttribute BookingForm booking,
    		                  @RequestParam Map<String, String> allParams,
                              HttpSession session) throws IOException {
        
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember";

        // 1. ดึง ID ออกมาจาก Object ที่ถูก bind มาแล้ว
        // Spring จะนำค่า 1 จาก JSP ไปใส่ใน booking.getCeremony().getCeremonyId() ให้โดยอัตโนมัติ
        if (booking.getCeremony() == null || booking.getCeremony().getCeremonyId() == 0) {
            return "redirect:/booking?error=noCeremony";
        }

        int ceremonyId = booking.getCeremony().getCeremonyId();
        Ceremony ceremony = ceremonyService.getCeremonyById(ceremonyId);
        
        // 2. set ค่ากลับเข้าไปเพื่อให้แน่ใจว่าเป็น Object ที่สมบูรณ์
        booking.setCeremony(ceremony);
        booking.setMember(loginUser);

     // รวบรวม imageBase64[0], imageBase64[1], ... จาก allParams
        List<String> imageBase64List = new ArrayList<>();
        for (int i = 0; ; i++) {
            String val = allParams.get("imageBase64[" + i + "]");
            if (val == null) break;
            imageBase64List.add(val);
        }

        if (!imageBase64List.isEmpty()) {
            try {
                String uploadDir = System.getProperty("user.dir") + "/uploads/address/";
                new java.io.File(uploadDir).mkdirs();
                List<String> fileNames = new ArrayList<>();
                for (String base64 : imageBase64List) {
                    if (base64 != null && base64.contains(",")) {
                        String data = base64.split(",")[1];
                        byte[] bytes = java.util.Base64.getDecoder().decode(data);
                        String fileName = System.currentTimeMillis() + "_"
                                + java.util.UUID.randomUUID().toString().substring(0, 8) + ".jpg";
                        java.nio.file.Files.write(java.nio.file.Paths.get(uploadDir + fileName), bytes);
                        fileNames.add(fileName);
                    }
                }
                booking.setAddressImage(String.join(",", fileNames));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // 2. บันทึกทุกอย่างลง Database ในคราวเดียว (Transaction)
        // ตรงนี้คือการนำค่า addressImage ที่ set ไว้ข้างบน ลงไปในตาราง booking
        BookingForm saved = bookingService.saveBooking(booking);
        return "redirect:/viewBooking/" + saved.getBookingId();
    }
    

    @GetMapping("/viewBooking/{id}")
    public String viewBooking(@PathVariable String id, Model model, HttpSession session) {
        BookingForm booking = bookingService.getBookingById(id);
        if (booking == null) return "redirect:/home";

        boolean alreadyReviewed = reviewService.hasAlreadyReviewed(id);

        // เพิ่มแค่นี้
        List<Item> pintoItems = itemService.getItemsByTypeName("ภัตตาหารปิ่นโต");
        List<Item> sanghatharnItems = itemService.getItemsByTypeName("สังฆทาน");

        model.addAttribute("booking", booking);
        model.addAttribute("hasReview", alreadyReviewed);
        model.addAttribute("pintoItems", pintoItems);
        model.addAttribute("sanghatharnItems", sanghatharnItems);
        return "viewBooking";
    }
    
    @GetMapping("/latestBooking")
    public String viewLatestBooking(HttpSession session) {
        Member user = (Member) session.getAttribute("user");
        if (user == null) return "redirect:/loginMember";

        // ลองดึงข้อมูล
        BookingForm latest = bookingService.getLatestBookingByMember(user.getMemberId());

        if (latest != null && latest.getBookingId() != null) {
            //  ถ้าเจอ ให้ส่งไปหน้าสรุป
            return "redirect:/viewBooking/" + latest.getBookingId();
        } else {
            //  ถ้าไม่เจอ (เช่น สมาชิกใหม่ยังไม่เคยจอง) ให้ส่งไปหน้าจองใหม่แทน
            return "redirect:/booking"; 
        }
    }
    
 // เพิ่มใน BookingFormController.java
    @GetMapping("/booking/cancel/{id}")
    public String cancelBooking(@PathVariable String id, HttpSession session, RedirectAttributes ra) {
        Member loginUser = (Member) session.getAttribute("user");
        if (loginUser == null) return "redirect:/loginMember";
        
        try {
            // เปลี่ยนมาเรียกใช้ระบบปฏิเสธ/ยกเลิกงาน เพื่อสับเปลี่ยนสถานะเป็น Rejected หรือ Cancelled ใน DB
            bookingService.rejectBooking(id);
            ra.addFlashAttribute("success", "ยกเลิกรายการจองสำเร็จแล้ว");
        } catch(Exception e) {
            ra.addFlashAttribute("error", "เกิดข้อผิดพลาดในการยกเลิก: " + e.getMessage());
        }
        
        // เด้งกลับหน้าหลัก (Home) ทันทีตามต้องการ ไม่แช่ค้างไว้ที่เดิมให้ปวดตับครับ!
        return "redirect:/home";
    }
    //=====================
    
    
}