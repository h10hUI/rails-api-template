require "rails_helper"

RSpec.describe "PostAPI", type: :request do
  it "全てのポストを取得する" do
    FactoryBot.create_list(:post, 10)

    get "/api/v1/posts"
    json = JSON.parse(response.body)

    # リクエストが成功することを確認
    expect(response).to have_http_status(:success)

    # 正しい数のデータが返されることを確認
    expect(json["data"].length).to eq(10)
  end

  it "特定のポストを取得する" do
    post = create(:post, title: "test-title")

    get "/api/v1/posts/#{post.id}"
    json = JSON.parse(response.body)

    # リクエストが成功することを確認
    expect(response).to have_http_status(:success)

    # 要求した特定ポストが返されることを確認
    expect(json["data"]["title"]).to eq("test-title")
  end

  it "新しいポストを作成する" do
    valid_params = { title: "title" }

    # データが作成されることを確認
    expect { post "/api/v1/posts", params: { post: valid_params } }.to change(Post, :count).by(+1)

    # リクエストが成功することを確認
    expect(response).to have_http_status(:success)
  end

  it "ポストを更新する" do
    post = create(:post, title: "old-title")
    put "/api/v1/posts/#{post.id}", params: { post: { title: "new-title" } }
    json = JSON.parse(response.body)

    # リクエストが成功することを確認
    expect(response).to have_http_status(:success)

    # ポストが更新されることを確認
    expect(json["data"]["title"]).to eq("new-title")
  end
end
