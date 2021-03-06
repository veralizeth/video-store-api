require "test_helper"

describe VideosController do
  VIDEO_FIELDS = ["id", "title", "overview", "release_date", "total_inventory", "available_inventory"].sort

  it "must get index" do
    get videos_path
    must_respond_with :success
    expect(response.header["Content-Type"]).must_include "json"
  end

  it "responds with JSON and success" do
    get videos_path

    expect(response.header["Content-Type"]).must_include "json"
    must_respond_with :ok
  end

  it "will return all proper field for all of videos " do
    # Act
    get videos_path

    # getting the body. JSON.parse: command take that json turn into a ruby array or hash.
    body = JSON.parse(response.body)
    #Assert
    expect(body).must_be_instance_of Array
    body.each do |video|
      expect(video).must_be_instance_of Hash
      expect(video.keys.sort).must_equal ["available_inventory", "id", "release_date", "title"]
    end
  end

  it "returns an empty array if not customers exist" do
    Video.destroy_all
    # Act
    get videos_path

    # getting the body. JSON.parse: command take that json turn into a ruby array or hash.
    body = JSON.parse(response.body)
    #Assert
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal 0
  end

  describe "show" do
    #Nominal case
    it "will return a hash with the proper fields for an existing video" do
      video = videos(:video_1)

      get video_path(video.id)
      #act
      must_respond_with :success

      body = JSON.parse(response.body)

      expect(response.header["Content-Type"]).must_include "json"

      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal ["available_inventory", "overview", "release_date", "title", "total_inventory"]
    end

    it "will return a 404 request with json for a non-existent video" do
      get video_path(-1)
      must_respond_with :not_found
      body = JSON.parse(response.body)
      
      expect(body).must_be_instance_of Hash
      expect(body["errors"]).must_equal ["Not Found"]
    end
  end

  describe "create video" do 
    let(:video_data) {
      { 
        video: {
        title: "Some Movie", 
        overview: "Some Overview", 
        release_date: "1/1/2020", 
        total_inventory: 10, 
        available_inventory: 5
        }
      }
    }

    it "cannot create video if no title" do
      video_data[:video][:title] = nil 

      expect {
        post videos_path, params: video_data
      }.must_differ "Video.count", 0
      
      must_respond_with :bad_request
    end

    it "cannot create video if no overview" do
      video_data[:video][:overview] = nil 
      
      expect {
        post videos_path, params: video_data
      }.must_differ "Video.count", 0
      
      must_respond_with :bad_request
    end

    it "cannot create video if no release_date" do
      video_data[:video][:release_date] = nil 
      
      expect {
        post videos_path, params: video_data
      }.must_differ "Video.count", 0
      
      must_respond_with :bad_request
    end

    it "cannot create video if no total_inventory" do
      video_data[:video][:total_inventory] = nil 
      
      expect {
        post videos_path, params: video_data
      }.must_differ "Video.count", 0
      
      must_respond_with :bad_request
    end

    it "cannot create video if no available_inventory" do
      video_data[:video][:available_inventory] = nil 
      
      expect {
        post videos_path, params: video_data
      }.must_differ "Video.count", 0
      
      must_respond_with :bad_request
    end
  end
end
