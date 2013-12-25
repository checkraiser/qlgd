#encoding: utf-8
class EnrollmentsController < ApplicationController
  
  def index       	
   	@lich = LichTrinhGiangDay.find(params[:lich_id])
    enrollments = @lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| EnrollmentDecorator.new(en,@lich) }.map {|e| EnrollmentSerializer.new(e)}
    render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
  end
  def settinglop
    @lich = LichTrinhGiangDay.find(params[:lich_id])
    render json: {:error => 'Lịch giảng dạy không tìm thấy'} unless @lich
    @lop = @lich.lop_mon_hoc
    @lop.settings ||= {}
    @lop.settings["so_tiet_ly_thuyet"] = params[:lop][:so_tiet_ly_thuyet].to_i
    @lop.settings["so_tiet_thuc_hanh"] = params[:lop][:so_tiet_thuc_hanh].to_i
    @lop.start!
    @lop.save!
    enrollments = @lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| EnrollmentDecorator.new(en,@lich) }.map {|e| EnrollmentSerializer.new(e)}
    render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
  end
  def update  	
  	@lich = LichTrinhGiangDay.find(params[:lich_id])
    render json: {:error => 'Lịch giảng dạy không tìm thấy'} unless @lich
    @sv= SinhVien.find(params[:enrollment][:sinh_vien_id])
    render json: {:error => 'Sinh viên không tìm thấy'} unless @sv
  	@attendance = @lich.attendances.where(sinh_vien_id: @sv.id).first_or_create!
    render json: {:error => 'Điểm danh không tìm thấy'} unless @attendance
    if params[:stat] == 'vang'
  	  @attendance.turn(params[:enrollment][:phep])    
    elsif params[:stat] == 'plus'
      @attendance.plus
    elsif params[:stat] == 'minus'
      @attendance.minus
    elsif params[:stat] == 'phep'
      @attendance.turn_phep
    elsif params[:stat] == 'note'
      @attendance.set_note(params[:enrollment][:note])
    end
    @attendance.save!  
    #attendance.mark_absent(false)
    #lich = LichTrinhGiangDay.find(params[:lich_id])
    enrollments = @lich.lop_mon_hoc.enrollments    
    results = enrollments.map {|en| EnrollmentDecorator.new(en,@lich) }.map {|e| EnrollmentSerializer.new(e)}
    render json: {info: {lop: LopMonHocSerializer.new(@lich.lop_mon_hoc),  lich: LichTrinhGiangDaySerializer.new(@lich.decorate)}, enrollments: results}.to_json
  end
  def test
    
    attendance = Attendance.find(1)    
    attendance.turn(false)
    attendance.save!
    render json: {res: attendance.so_tiet_vang, state: attendance.state, lich: attendance.lich_trinh_giang_day.so_tiet_moi}
  end
end  