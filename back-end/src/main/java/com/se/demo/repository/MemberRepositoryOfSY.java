

import java.lang.reflect.Member;

import com.se.demo.entity.MemberEntityOfSY;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberRepositoryOfSY extends JpaRepository<MemberEntityOfSY, Integer> {
}
