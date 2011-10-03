Factory.define :user do |f|
  f.sequence(:name) { |n| "mssola" }
  f.sequence(:email) { |n| "foo#{n}@example.com" }
  f.sequence(:password_confirmation) { |n| "secret" }
  f.password "secret"
end
