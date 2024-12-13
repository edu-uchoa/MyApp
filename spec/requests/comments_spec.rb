require 'rails_helper'

RSpec.describe "Comments API", type: :request do
  let!(:user) { create(:user) } # Um usuário para autenticação
  let!(:post) { create(:post) } # Um post existente
  let!(:comment) { create(:comment, post: post, user: user) } # Um comentário associado ao post
  let(:headers) { { "Authorization" => "Bearer #{user.authentication_token}" } } # Headers para autenticação

  describe "POST /posts/:post_id/comments" do
    let(:valid_attributes) { { comment: { content: "Este é um comentário!" } } }

    context "quando o usuário está autenticado" do
      it "cria um novo comentário" do
        expect {
          post "/posts/#{post.id}/comments", params: valid_attributes, headers: headers
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["content"]).to eq("Este é um comentário!")
      end
    end

    context "quando o usuário não está autenticado" do
      it "retorna erro de autorização" do
        post "/posts/#{post.id}/comments", params: valid_attributes
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /posts/:post_id/comments/:id" do
    context "quando o usuário é o autor do comentário" do
      it "exclui o comentário" do
        expect {
          delete "/posts/#{post.id}/comments/#{comment.id}", headers: headers
        }.to change(Comment, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "quando o usuário não é o autor do comentário" do
      let!(:other_user) { create(:user) }
      let!(:other_headers) { { "Authorization" => "Bearer #{other_user.authentication_token}" } }

      it "retorna erro de autorização" do
        delete "/posts/#{post.id}/comments/#{comment.id}", headers: other_headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
