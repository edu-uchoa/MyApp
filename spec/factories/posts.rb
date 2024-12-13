FactoryBot.define do
  factory :post do
    title { "Título do Post" }
    body { "Este é o conteúdo do post." }
    user # Associa o post a um usuário
  end
end
