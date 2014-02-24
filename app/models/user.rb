class User < ActiveRecord::Base
  has_many :user_roles

  def orgs_and_ancestors(roleid)
    # get a list of nodes that this user has the specified role
    admins = self.user_roles.where(["role_id = ?",roleid]).select(:org_id)
    admins_orgs = admins.map {|o| o.org_id}
    # get a list of direct decendents
    children = Org.where(["Parent in (?) or id in (?)",admins_orgs,admins_orgs]).select(:id)
    children_orgs = children.map {|o| o.id}
    # see if any of these nodes have children
    grand_children = Org.where([" parent in (?)",children_orgs]).select(:id)
    grand_children_orgs = grand_children.map {|o| o.id}
    # merge and purge the 2 lists
    grand_children_orgs | children_orgs
  end

  def accessible_orgs(roleid)
    granted = orgs_and_ancestors(roleid)
    @role = Role.find_by_name("Denied")
    denied = orgs_and_ancestors(@role.id)
    granted - denied
  end

  def granted_access?(roleid, orgid)
    accessible_orgs(roleid).include?(orgid)  
  end

end
