Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :full_name
      String :github_user
      String :email
      String :crypted_password
      String :gravatar_url
      String :organizations

      index :github_user
      index :email
    end

    create_table :standups do
      primary_key :id
      String :previous
      String :next
      String :blockers
      Date :date
      foreign_key :user_id, :users

      index :date
      index :user_id
    end
  end

  down do
    drop_table :users
    drop_table :standups
  end
end

