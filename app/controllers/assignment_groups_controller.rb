#encoding: utf-8
class AssignmentGroupsController < ApplicationController

	def reorder
		@lop = LopMonHoc.find(params[:id].to_i)
		@assignment_group = @lop.assignment_groups.find(params[:assignment_group_id].to_i);
		@assignment_group.insert_at(params[:position].to_i+1)
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	# post
	def create
		@lop = LopMonHoc.find(params[:id])
		@assignment_group = @lop.assignment_groups.create(giang_vien_id: params[:giang_vien_id], name: params[:name], weight: params[:weight])
		@assignment_group.move_to_bottom
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	
	# delete assignment group
	def delete
		@lop = LopMonHoc.find(params[:id])
		@as = @lop.assignment_groups.find(params[:assignment_group_id]);
		@as.destroy if @as
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	# update assignment group
	def update
		@lop = LopMonHoc.find(params[:id])
		@as = @lop.assignment_groups.find(params[:assignment_group_id]);
		if @as
			@as.name = params[:name]
			@as.weight = params[:weight]
			@as.save!
		end
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json
	end
	def change
		@lop = LopMonHoc.find(params[:id])
		@assignment_group = @lop.assignment_groups.find(params[:assignment_group_id])
		@assignment = @lop.assignments.assignment_group = @assignment_group
		@assignment.insert_at(params[:positin].to_i + 1);
		@assignment.save!
		results = @lop.assignment_groups.map {|g| g and LopMonHocAssignmentGroupSerializer.new(g)}
		render json: results.to_json		
	end
end