package com.springboot.repository;
 
import com.springboot.model.Member;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
 
@Repository
public interface MemberRepository extends JpaRepository<Member, Integer> { 
 
    Optional<Member> findByMemberEmail(String memberEmail);
 
    Optional<Member> findByMemberEmailAndMemberPassword(String memberEmail, String memberPassword);
 
    boolean existsByMemberEmail(String memberEmail);
}