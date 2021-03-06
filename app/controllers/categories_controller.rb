class CategoriesController < ApplicationController
  def new
    @children = Category.find(params[:parent_id]).children
    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    # カテゴリ名を取得するために@categoryにレコードをとってくる
    @category = Category.find_by(id: params[:id])
    # 親カテゴリーを選択していた場合の処理
    if @category.ancestry == nil
      # Categoryモデル内の親カテゴリーに紐づく孫カテゴリーのidを取得
      category = @category.indirect_ids
      # 孫カテゴリーに該当するitemsテーブルのレコードを入れるようの配列を用意
      @items = []
      # find_itemメソッドで処理
      find_item(category)
      # 孫カテゴリーを選択していた場合の処理
    elsif @category.ancestry.include?("/")
      # Categoryモデル内の親カテゴリーに紐づく孫カテゴリーのidを取得
      @items = Item.where(grandchild_category_id: params[:id])

    # 子カテゴリーを選択していた場合の処理
    else
      category = @category.child_ids
      # 孫カテゴリーに該当するitemsテーブルのレコードを入れるようの配列を用意
      @items = []
      # find_itemメソッドで処理
      find_item(category)
    end
  end


  def find_item(category)
    category.each do |id|
      item_array = Item.includes(:images).where(grandchild_category_id: id)
      # find_by()メソッドで該当のレコードがなかった場合、itemオブジェクトに空の配列を入れないようにするための処理
      if item_array.present?
        item_array.each do |item|
          if item.present?
            # find_by()メソッドで該当のレコードが見つかった場合、@item配列オブジェクトにそのレコードを追加する
            @items.push(item)
          end
        end
      end
    end
  end
end