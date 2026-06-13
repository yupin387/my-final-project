package com.springboot.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Questionsdetail")
public class QuestionsDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "questionsid")
    private int questionsId;

    @Column(name = "questionstext", nullable = false)
    private String questionsText;

    @ManyToOne
    @JoinColumn(name = "ceremonyid")
    private Ceremony ceremony;

    public QuestionsDetail() {}

    public QuestionsDetail(String questionsText, Ceremony ceremony) {
        this.questionsText = questionsText;
        this.ceremony = ceremony;
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

    public Ceremony getCeremony() {
        return ceremony;
    }

    public void setCeremony(Ceremony ceremony) {
        this.ceremony = ceremony;
    }
}