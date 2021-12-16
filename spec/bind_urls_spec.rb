require_relative "./env.rb"
RSpec.describe BindUrl do
  describe "xxx_urls" do
    let(:user) { User.new(pictures: ["a.jpg", "b.jpg"]) }

    it "should return url array" do
      expect(user.picture_urls).to eq(["https://oss.example.com/User/pictures/a.jpg", "https://oss.example.com/User/pictures/b.jpg"])
    end

    context "url with params" do
      it "should add params to query" do
        expect(user.picture_urls(a: 1)).to eq(["https://oss.example.com/User/pictures/a.jpg?a=1", "https://oss.example.com/User/pictures/b.jpg?a=1"])
      end
    end

    context "when pictures changed" do
      it "should change url" do
        user.picture_urls
        user.pictures = ["b.jpg", "a.jpg"]
        expect(user.picture_urls).to eq(["https://oss.example.com/User/pictures/b.jpg", "https://oss.example.com/User/pictures/a.jpg"])
      end
    end
  end

  describe "xxx_urls=" do
    let(:user) { User.new }

    it "should update value" do
      allow_any_instance_of(BindUrl::Binder).to receive(:download_as_tmp_file).and_return(Tempfile.new(["", ".jpg"]))
      allow(SecureRandom).to receive(:uuid).and_return("x")
      user.picture_urls = ["https://oss.example.com/User/pictures/a.jpg"]
      expect(user.pictures).to eq(["x.jpg"])
    end
  end

  describe "upload_xxx_url(index, url)" do
    let(:user) { User.new(pictures: ["a.jpg", "b.jpg"]) }

    it "should update value" do
      allow_any_instance_of(BindUrl::Binder).to receive(:download_as_tmp_file).and_return(Tempfile.new(["", ".jpg"]))
      allow(SecureRandom).to receive(:uuid).and_return("x")
      user.upload_picture_url(1, "https://oss.example.com/User/pictures/a.jpg")
      expect(user.pictures).to eq(["a.jpg", "x.jpg"])
    end
  end

  describe "xxx_files=" do
    let(:user) { User.new }

    it "should update value" do
      allow(SecureRandom).to receive(:uuid).and_return("x")
      user.picture_files = [Tempfile.new(["", ".jpg"])]
      expect(user.pictures).to eq(["x.jpg"])
    end
  end
  describe "upload_xxx_file(index, file)" do
    let(:user) { User.new(pictures: ["a.jpg", "b.jpg"]) }

    it "should update value" do
      allow_any_instance_of(BindUrl::Binder).to receive(:download_as_tmp_file).and_return(Tempfile.new(["", ".jpg"]))
      allow(SecureRandom).to receive(:uuid).and_return("x")
      user.upload_picture_file(1, Tempfile.new(["", ".jpg"]))
      expect(user.pictures).to eq(["a.jpg", "x.jpg"])
    end
  end
end
