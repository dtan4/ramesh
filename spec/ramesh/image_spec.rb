require "spec_helper"

module Ramesh
  describe Image do
    let(:image_name) do
      "201405222005"
    end

    let(:mesh_url) do
      "http://tokyo-ame.jwa.or.jp/mesh/000/#{image_name}.jpg"
    end

    let(:background_url) do
      "http://tokyo-ame.jwa.or.jp/map/map000.jpg"
    end

    let(:mask_url) do
      "http://tokyo-ame.jwa.or.jp/map/msk000.png"
    end

    before do
      stub_request(:get, mesh_url)
        .to_return(status: 200, body: open(fixture_path("lena.png")).read)
      stub_request(:get, background_url)
        .to_return(status: 200, body: open(fixture_path("lena.png")).read)
      stub_request(:get, mask_url)
        .to_return(status: 200, body: open(fixture_path("lena.png")).read)
    end

    describe "#background_image" do
      it "should download the background image" do
        described_class.background_image
        expect(a_request(:get, background_url)).to have_been_made.once
      end
    end

    describe "#mask_image" do
      it "should download the mask image" do
        described_class.mask_image
        expect(a_request(:get, mask_url)).to have_been_made.once
      end
    end

    describe "#initialize" do
      it "should composite the moment image" do
        described_class.new(image_name)
        expect(a_request(:get, mesh_url)).to have_been_made.once
        expect(a_request(:get, background_url)).to have_been_made.once
        expect(a_request(:get, mask_url)).to have_been_made.once
      end
    end
  end
end
