require 'spec_helper'

describe Org do
    before(:all) do
    # Create the basic organiation structure

    myorg = Org.create(:name => "Root Org")
    org_root_id = Org.last.id
    myorg.update(parent: org_root_id)

    Org.create(:name => "Org 1", :parent => org_root_id)
    org_1_id = Org.last.id
  
    Org.create(:name => "Child 1 Org 1", :parent => org_1_id)
    Org.create(:name => "Child 2 Org 1", :parent => org_1_id)
  
    Org.create(:name => "Org 2", :parent => org_root_id)
    org_2_id = Org.last.id

    Org.create(:name => "Org 3", :parent => org_root_id)
    org_3_id = Org.last.id
  
    Org.create(:name => "Child 1 Org 3", :parent => org_3_id)
    Org.create(:name => "Child 2 Org 3", :parent => org_3_id)

    Org.create(:name => "Org 4", :parent => org_root_id)
    org_4_id = Org.last.id
    Org.create(:name => "Child 1 Org 4", :parent => org_4_id)
    Org.create(:name => "Child 2 Org 4", :parent => org_4_id)
    Org.create(:name => "Child 3 Org 4", :parent => org_4_id)
    Org.create(:name => "Child 4 Org 4", :parent => org_4_id)

    Role.create(:name => "Admin")
    Role.create(:name => "User")
    Role.create(:name => "Denied")

    User.create(:name => "Joe")
    User.create(:name => "Larry")
    User.create(:name => "Moe")
    User.create(:name => "Curly")
  end 

 it "Should return false for User with no assignments" do
    @role = Role.find_by_name("User")
    @user = User.find_by_name("Joe")
    @org = Org.find_by_name("Root Org")
    user_access = @user.granted_access?(@role.id, @org.id)
    expect(user_access).to be false
  end 

it "Should return false for Admin with no assignments" do
    @role = Role.find_by_name("Admin")
    @user = User.find_by_name("Joe")
    @org = Org.find_by_name("Root Org")
    admin_access = @user.granted_access?(@role.id, @org.id)
    expect(admin_access).to be false
  end 

  it "Should return true for Admin access on a specified top level node" do
    @role = Role.find_by_name("Admin")
    @user = User.find_by_name("Joe")
    @org = Org.find_by_name("Root Org")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
    admin_access = @user.granted_access?(@role.id, @org.id)
    expect(admin_access).to be true
  end 

  it "Should return true for Admin access on a specified low level node" do
    @role = Role.find_by_name("Admin")
    @user = User.find_by_name("Joe")
    @org = Org.find_by_name("Child 4 Org 4")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
    admin_access = @user.granted_access?(@role.id, @org.id)
    expect(admin_access).to be true
  end  

  it "As Root Admin Joe should have Admin access to all nodes" do
    @role = Role.find_by_name("Admin")
    @user = User.find_by_name("Joe")
    @org = Org.find_by_name("Root Org")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
    # get a list of all org ids
    all = Org.all.select(:id)
    all_orgs = all.map {|o| o.id}
    # get a list Joe's Admin nodes
    orgs = @user.accessible_orgs(@role.id)
    my_orgs = orgs.map {|o| o.to_i}
    expect(my_orgs).to eq(all_orgs)
  end

  it "Should have all nodes except those set to Denied" do
    @user = User.find_by_name("Joe")
    @role = Role.find_by_name("Denied")
    @org = Org.find_by_name("Org 3")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
    @role = Role.find_by_name("Admin")
    @org = Org.find_by_name("Root Org")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
 
    # get a list of all org ids 
  
    all = Org.all.select(:id)
    all_orgs = all.map {|o| o.id}

    # get the specified and inherited nodes

    denied = []
    denied << Org.find_by_name("Org 3").id
    denied << Org.find_by_name("Child 1 Org 3").id
    denied << Org.find_by_name("Child 2 Org 3").id

    # get a list Joe's Admin nodes
 
    orgs = @user.accessible_orgs(@role.id)
    my_orgs = orgs.map {|o| o.to_i}
    expect(my_orgs).to eq(all_orgs - denied)
  end

  it "Should only have Root org Admin when denied to all Orgs" do
    @user = User.find_by_name("Joe")
    @role = Role.find_by_name("Denied")
    @org = Org.find_by_name("Org 1")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
    @org = Org.find_by_name("Org 2")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
    @org = Org.find_by_name("Org 3")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
    @org = Org.find_by_name("Org 4")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
    @role = Role.find_by_name("Admin")
    @org = Org.find_by_name("Root Org")
    @user.user_roles.create(:user_id => @user.id, :role_id => @role.id, :org_id => @org.id)
 
    # get a list of all org ids 
  
    all = Org.all.select(:id)
    all_orgs = all.map {|o| o.id}

    # get the specified and inherited nodes

    denied = []
    denied << Org.find_by_name("Org 3").id
    denied << Org.find_by_name("Child 1 Org 3").id
    denied << Org.find_by_name("Child 2 Org 3").id
    denied << Org.find_by_name("Org 1").id
    denied << Org.find_by_name("Child 1 Org 1").id
    denied << Org.find_by_name("Child 2 Org 1").id
    denied << Org.find_by_name("Org 2").id
    denied << Org.find_by_name("Org 3").id
    denied << Org.find_by_name("Child 1 Org 3").id
    denied << Org.find_by_name("Child 2 Org 3").id
    denied << Org.find_by_name("Org 4").id
    denied << Org.find_by_name("Child 1 Org 4").id
    denied << Org.find_by_name("Child 2 Org 4").id
    denied << Org.find_by_name("Child 3 Org 4").id
    denied << Org.find_by_name("Child 4 Org 4").id

    # get a list Joe's Admin nodes
 
    orgs = @user.accessible_orgs(@role.id)
    my_orgs = orgs.map {|o| o.to_i}
    expect(my_orgs).to eq(all_orgs - denied)
  end
end