FactoryBot.define do
  factory :comment do
    content { "Este é um comentário." }
    user # Associa o comentário a um usuário
    post # Associa o comentário a um post
  end
end
