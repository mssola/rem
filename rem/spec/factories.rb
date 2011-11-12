
Factory.sequence(:name) { |n| "user#{n}" }
Factory.sequence(:rname) { |n| "route#{n}" }
Factory.sequence(:pname) { |n| "place#{n}" }
Factory.sequence(:email) { |n| "address#{n}@example.com" }


Factory.define :user do |f|
  f.name { Factory.next(:name) }
  f.email { Factory.next(:email) }
  f.sequence(:password_confirmation) { |n| "secret" }
  f.password "secret"
end

Factory.define :route do |f|
  f.name { Factory.next(:rname) }
  f.user_id rand(42)
  f.protected false
  f.rating 0
  f.desc 'TestTestTest'
end

Factory.define :place do |f|
  f.name { Factory.next(:pname) }
  f.route_id rand(42)
end
