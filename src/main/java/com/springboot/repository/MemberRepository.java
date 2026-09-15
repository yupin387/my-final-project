package com.springboot.repository;
 
import com.springboot.model.Member;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
 

@Repository
public interface MemberRepository extends JpaRepository<Member, Integer> {

 // ค้นหาสมาชิกจากอีเมล (ใช้ตอนเช็คว่ามีอีเมลนี้ในระบบหรือยัง หรือดึงข้อมูลสมาชิกจากอีเมล)
 Optional<Member> findByMemberEmail(String memberEmail);

 // ค้นหาสมาชิกจากคู่อีเมล+รหัสผ่าน ใช้สำหรับตรวจสอบตอนล็อกอิน
 Optional<Member> findByMemberEmailAndMemberPassword(String memberEmail, String memberPassword);

 // เช็คว่ามีอีเมลนี้ถูกใช้งานในระบบแล้วหรือยัง (ใช้ตอนสมัครสมาชิกใหม่ เพื่อกันอีเมลซ้ำ)
 boolean existsByMemberEmail(String memberEmail);
}