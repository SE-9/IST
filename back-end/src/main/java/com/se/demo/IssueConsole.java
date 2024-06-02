package com.se.demo;

import com.se.demo.dto.ChangeIssueStateRequest;
import com.se.demo.dto.IssueDTO;
import com.se.demo.dto.ResponseIssueDTO;
import com.se.demo.entity.IssueEntity;
import com.se.demo.service.IssueService;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.http.*;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;


import java.net.http.HttpClient;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
@Getter
@Setter
@NoArgsConstructor
@SpringBootApplication
public class IssueConsole {
    public static void main(String[] args) {
        String baseUrl = "http://localhost:8081/issue";




        Scanner scanner = new Scanner(System.in);

        RestTemplate restTemplate = new RestTemplate();


        // 스프링 부트 애플리케이션 컨텍스트를 로드합니다.
        ConfigurableApplicationContext context = SpringApplication.run(IssueConsole.class, args);
        // 이슈 생성
        IssueService issueService = context.getBean(IssueService.class);
        IssueDTO issueDTO = new IssueDTO();



        while (true) {
            System.out.println("Choose an option:");
            System.out.println("1. 특정 이슈 상세 조회");
            System.out.println("2. 나의 모든 이슈 조회");
            System.out.println("3. 이슈 생성");
            System.out.println("4. 이슈 상태 변경");
            System.out.println("5. 이슈 검색");
            System.out.println("6. 종료");
            int option = scanner.nextInt();

            switch (option) {
                case 1:
                    findIssueById(scanner, restTemplate, baseUrl);
                    break;
                case 2:
                    findMyIssues(scanner, restTemplate, baseUrl);
                    break;
                case 3:
                    createIssue(scanner, issueService);
                    break;
                case 4:
                    updateIssueState(scanner, issueService);
                    break;
                case 5:
                    searchIssues(scanner, restTemplate, baseUrl);
                    break;
                case 6:
                    System.exit(0);
                    break;
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        }
    }

    private static void findIssueById(Scanner scanner, RestTemplate restTemplate, String baseUrl) {
        System.out.println("특정 이슈 상세 조회");
        System.out.print("Enter Issue ID: ");
        int issueId = scanner.nextInt();
        ResponseEntity<ResponseIssueDTO> findByIdResponse = restTemplate.getForEntity(baseUrl + "/" + issueId, ResponseIssueDTO.class);
        ResponseIssueDTO issue = findByIdResponse.getBody();
        if (issue != null) {
            System.out.println("Issue Details:");
            System.out.println("ID: " + issue.getId());
            System.out.println("Title: " + issue.getTitle());
            System.out.println("Description: " + issue.getDescription());
            System.out.println("Created Date: " + issue.getCreatedDate());
            //System.out.println("Updated Date: " + issue.getUpdatedDate());
            System.out.println("Creator ID: " + issue.getCreatorId());
        } else {
            System.out.println("Issue not found with ID: " + issueId);
        }
    }

    private static void findMyIssues(Scanner scanner, RestTemplate restTemplate, String baseUrl) {
        System.out.println("나의 모든 이슈 조회");
        System.out.print("Enter UserId: ");
        int userId = scanner.nextInt();
        ResponseEntity<ResponseIssueDTO[]> findMyIssuesResponse = restTemplate.getForEntity(baseUrl + "/my/" + userId, ResponseIssueDTO[].class);
        ResponseIssueDTO[] issues = findMyIssuesResponse.getBody();
        if (issues != null && issues.length > 0) {
            for (ResponseIssueDTO issue : issues) {
                System.out.println(issue);
            }
        } else {
            System.out.println("No issues found for User ID: " + userId);
        }
    }

    private static void createIssue(Scanner scanner, IssueService issueService) {
        System.out.println("이슈 생성");
        IssueDTO issueDTO = new IssueDTO();

        System.out.println("Enter issue title: ");
        String title = scanner.next();
        issueDTO.setTitle(title);

        System.out.println("Enter issue description: ");
        String description = scanner.next();
        issueDTO.setDescription(description);

        System.out.println("Enter project ID: ");
        int projectId = scanner.nextInt();
        issueDTO.setProject_id(projectId);

        System.out.println("Enter reporter ID: ");
        int reporterId = scanner.nextInt();
        issueDTO.setReporter_id(reporterId);

        IssueEntity createdIssueEntity = issueService.createIssue(issueDTO);
        System.out.println("Created Issue: " + createdIssueEntity);
    }

    private static void updateIssueState(Scanner scanner, IssueService issueService) {
        IssueDTO issueDTO = new IssueDTO();
        System.out.println("이슈 상태 변경");
        System.out.println("Enter issue title: ");
        String title = scanner.next();
        issueDTO.setTitle(title);

        ChangeIssueStateRequest changeIssueStateRequest = new ChangeIssueStateRequest();
        System.out.print("Enter old state: ");
        String oldState = scanner.next();
        changeIssueStateRequest.setOldState(oldState);

        System.out.print("Enter new state: ");
        String newState = scanner.next();
        changeIssueStateRequest.setNewState(newState);

        System.out.println("Enter reporter ID: ");
        int reporterId = scanner.nextInt();
        issueDTO.setReporter_id(reporterId);


        System.out.print("Enter assignee ID: ");
        int assigneeId = scanner.nextInt();
        changeIssueStateRequest.setAssignee_id(assigneeId);
        IssueEntity createdIssueEntity = issueService.createIssue(issueDTO);


        IssueDTO updateIssueStateResponse = issueService.updateIssue(issueDTO);
        System.out.println("Update Issue State Response: " + updateIssueStateResponse);

    }

    private static void searchIssues(Scanner scanner, RestTemplate restTemplate, String baseUrl) {
        System.out.print("Enter keyword to search for issues: ");
        String keyword = scanner.next();

        List<IssueDTO> searchResults;
        try {
            String searchUrl = baseUrl + "/issues/search?keyword=" + keyword;
            ResponseEntity<IssueDTO[]> response = restTemplate.getForEntity(searchUrl, IssueDTO[].class);
            searchResults = Arrays.asList(response.getBody());
        } catch (HttpClientErrorException e) {
            if (e.getStatusCode() == HttpStatus.NOT_FOUND) {
                System.out.println("No issues found with the keyword: " + keyword);
            } else {
                System.err.println("Error searching for issues: " + e.getMessage());
            }
            return;
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            return;
        }

        if (searchResults != null && !searchResults.isEmpty()) {
            System.out.println("Search Results:");
            for (IssueDTO issue : searchResults) {
                System.out.println(issue);
            }
        } else {
            System.out.println("No issues found with the keyword: " + keyword);
        }
    }

}

// ResponseIssueDTO 클래스 정의 (필드와 getter 메서드 포함)

