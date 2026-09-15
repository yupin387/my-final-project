package com.springboot.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "Questionsdetail")
public class QuestionsDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "questionsid")
    private int questionsId;

    @Column(name = "questionstext", nullable = false, unique = true)
    private String questionsText;


    @ManyToMany(mappedBy = "questions")
    private List<Ceremony> ceremonies;

    public QuestionsDetail() {}

    public QuestionsDetail(String questionsText) {
        this.questionsText = questionsText;
    }

    public int getQuestionsId() {
        return questionsId;
    }

    public void setQuestionsId(int questionsId) {
        this.questionsId = questionsId;
    }

    public String getQuestionsText() {
        return questionsText;
    }

    public void setQuestionsText(String questionsText) {
        this.questionsText = questionsText;
    }

    public List<Ceremony> getCeremonies() {
        return ceremonies;
    }

    public void setCeremonies(List<Ceremony> ceremonies) {
        this.ceremonies = ceremonies;
    }
}