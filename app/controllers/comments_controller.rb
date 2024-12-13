class CommentsController < ApplicationController
  before_action :set_post
  before_action :authenticate_user!, only: [ :create, :destroy ] # Garantir que o usuário esteja logado
  before_action :set_comment, only: [ :destroy ]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user # Associar o comentário ao usuário logado

    if @comment.save
      redirect_to @post, notice: "Comentário adicionado com sucesso!"
    else
      redirect_to @post, alert: "Ocorreu um erro ao adicionar o comentário."
    end
  end

  def destroy
    # Verifique se o usuário é o autor do comentário ou um administrador (opcional)
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      redirect_to @post, notice: "Comentário excluído com sucesso."
    else
      redirect_to @post, alert: "Você não pode excluir este comentário."
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
