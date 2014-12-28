class AddUserMigration < Mongoid::Migration
  def self.up    
    admin = User.create!(email: 'admin01@example.com', password: 'password')
    admin.add_role :admin
    puts "Create admin: " << admin.email
  end

  def self.down
    admin = User.find_by(email: 'admin01@example.com')
    puts "Detelet admin: " << admin.email
    admin.delete
  end
end