require_relative "./env.rb"
RSpec.describe BindUrl do
  it "has a version number" do
    expect(BindUrl::VERSION).not_to be nil
  end

  context "normal usage" do
    describe "xxx_url" do
      context "with value present" do
        let(:user) { User.new(photo: "a.jpg") }

        it "should return valid value" do
          expect(user.photo_url).to eq("https://oss.example.com/User/photo/a.jpg")
        end
      end

      context "with value nil" do
        let(:user) { User.new(photo: nil) }

        it "should return nil" do
          expect(user.photo_url).to eq(nil)
        end
      end


      context "with value changed" do
        let(:user) { User.new(photo: "a.jpg") }

        it "should return valid value" do
          expect(user.photo_url).to eq("https://oss.example.com/User/photo/a.jpg")
          user.photo = "b.jpg"
          expect(user.photo_url).to eq("https://oss.example.com/User/photo/b.jpg")
        end
      end
    end

    describe "xxx_url=" do
      let(:user) { User.new }
      before(:each) do
        allow(SecureRandom).to receive(:uuid).and_return("x")
        allow_any_instance_of(BindUrl::Binder).to receive(:download_as_tmp_file).and_return(Tempfile.new(["", ".jpg"]))
      end

      it "should update value" do
        mocked_attr = "x.jpg"
        user.photo_url = "https://oss.example.com/User/photo/a.jpg"
        expect(user.photo).to eq(mocked_attr)
      end
    end

    describe "xxx_file=" do
      let(:user) { User.new }
      before(:each) do
        allow(SecureRandom).to receive(:uuid).and_return("x")
      end

      it "should update value" do
        user.photo_file = Tempfile.new(["", ".png"])
        expect(user.photo).to eq("x.png")
      end
    end
  end
end
