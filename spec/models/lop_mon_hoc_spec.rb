#encoding: utf-8
require 'spec_helper'

describe LopMonHoc do
  
  before(:each) do 
    Tenant.create(name: 'hk1', hoc_ky: '1', nam_hoc:'2013-2014')   
    d = Date.new(2014, 1, 13)
    (0..20).each do |t|
        Tuan.where(:stt => t+23, :tu_ngay => d + t.weeks, :den_ngay => d + t.weeks + 6.day).first_or_create!
    end
    @lop = LopMonHoc.create(ma_lop: 'ml1', ma_mon_hoc: 'mm1', ten_mon_hoc: 'tm1', settings: {})
  end
  it "should be created and removed" do              
    @lop.valid?.should be_true    
    @lop.pending?.should be_true
    @lop.start!
    @lop.started?.should be_true
    @lop.assignments.count.should == 5
    @lop.remove!
    @lop.removed?.should be_true
  end
  it "should create calendar" do 
    @gv = GiangVien.create(code: 'gv1', ten: 'name')
    thu = 2
    tiet_bat_dau = 1
    tuan_hoc_bat_dau = 23
    so_tuan = 3    
    @calendar = @lop.calendars.where(thu: thu, so_tuan: so_tuan, tiet_bat_dau: tiet_bat_dau, tuan_hoc_bat_dau: tuan_hoc_bat_dau, giang_vien_id: @gv.id).first_or_create!
    @calendar.schedule.count.should > 0
    @calendar2 = @lop.calendars.where(thu: thu, so_tuan: so_tuan, tiet_bat_dau: tiet_bat_dau, tuan_hoc_bat_dau: tuan_hoc_bat_dau, giang_vien_id: @gv.id).first_or_create!
    @calendar.should == @calendar2
    #:thu, :tiet_bat_dau, :tuan_hoc_bat_dau, :giang_vien_id
  end

  


  
end
