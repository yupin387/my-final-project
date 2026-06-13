package com.springboot.service;
 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.springboot.model.Member;
import com.springboot.repository.MemberRepository;
@Service
public class MemberService {
    @Autowired
    private MemberRepository memberRepository;
    // ล็อกอิน
    public Member login(String email, String password) {
        return memberRepository.findByMemberEmailAndMemberPassword(email, password)
                .orElse(null);
    }
    // บันทึกสมาชิกใหม่ (ไม่ต้องเจน ID เองแล้ว)
    public void saveMember(Member member) {
        memberRepository.save(member);
    }
    // ดึงข้อมูลสมาชิกด้วย ID (เปลี่ยนเป็น int)
    public Member getMemberById(int id) {
        return memberRepository.findById(id).orElse(null);
    }
    // อัปเดตข้อมูลโปรไฟล์
    @Transactional
    public void updateProfile(Member member, String newPassword) {
        // ค้นหาด้วย int ID
        Member existingMember = memberRepository.findById(member.getMemberId()).orElse(null);
        if (existingMember != null) {
            existingMember.setMemberFirstName(member.getMemberFirstName());
            existingMember.setMemberLastName(member.getMemberLastName());
            existingMember.setPhoneNumber(member.getPhoneNumber());
            existingMember.setMemberEmail(member.getMemberEmail());
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                existingMember.setMemberPassword(newPassword);
            }
            memberRepository.save(existingMember);
        }
    }
}