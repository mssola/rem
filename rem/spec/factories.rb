
Factory.sequence(:name) { |n| "user#{n}" }
Factory.sequence(:email) { |n| "address#{n}@example.com" }


Factory.define :user do |f|
  f.name { Factory.next(:name) }
  f.email { Factory.next(:email) }
  f.sequence(:password_confirmation) { |n| "secret" }
  f.password "secret"
end
