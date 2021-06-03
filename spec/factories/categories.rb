#rails g factory_bot:model category
# frabrica de categorias
FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Categoria #{n}" }
    description { Faker::Lorem.sentence }
  end
end
