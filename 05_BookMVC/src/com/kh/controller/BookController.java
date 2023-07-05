package com.kh.controller;

import java.util.ArrayList;
import com.kh.model.dao.BookDAO;
import com.kh.model.vo.Book;
import com.kh.model.vo.Member;
import com.kh.model.vo.Rent;

public class BookController {

	private BookDAO dao = new BookDAO();
	private Member member = new Member(); // 로그인 정보 담기
	
	public ArrayList<Book> printBookAll() {
		return null;
	}
	
	public boolean registerBook(Book book) {
		return false;
	}
	
	public boolean sellBook(int no) {
		return false;
	}
	
	public boolean registerMember(Member member) {
		return false;
	}
	
	public Member login(String id, String password) {
		return member;
	}
	
	public boolean deleteMember() {
		return false;
	}
	
	public boolean rentBook(int no) {
		return false;
	}
	
	public boolean deleteRent(int no) {
		return false;
	}
	
	public ArrayList<Rent> printRentBook() {
		return null;
	}
	
}
