require "spec_helper"
require "fileutils"

module Ramesh
  describe Image do
    let(:image_name) do
      "201405091845"
    end

    let(:filename) do
      "201405091845.jpg"
    end

    let(:tmpdir) do
      File.expand_path(File.join("..", "..", "tmp"), __FILE__)
    end

    let(:mesh_url) do
      "http://tokyo-ame.jwa.or.jp/mesh/000/#{image_name}.gif"
    end

    let(:background_url) do
      "http://tokyo-ame.jwa.or.jp/map/map000.jpg"
    end

    let(:mask_url) do
      "http://tokyo-ame.jwa.or.jp/map/msk000.png"
    end

    let(:fixture_image) do
      open(fixture_path("lena.png")).read
    end

    before do
      stub_request(:get, mesh_url)
        .to_return(status: 200, body: fixture_image)
      stub_request(:get, background_url)
        .to_return(status: 200, body: fixture_image)
      stub_request(:get, mask_url)
        .to_return(status: 200, body: fixture_image)
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
      context "without cached images" do
        it "should composite the moment image" do
          described_class.new(image_name)
          expect(a_request(:get, mesh_url)).to have_been_made.once
          expect(a_request(:get, background_url)).to have_been_made.once
          expect(a_request(:get, mask_url)).to have_been_made.once
        end
      end

      context "with cached images" do
        it "should composite the moment image" do
          image = double(composite: true)
          background_image = double(composite: image)
          mask_image = double(composite: image)

          described_class.new(image_name, background_image, mask_image)
          expect(a_request(:get, mesh_url)).to have_been_made.once
          expect(a_request(:get, background_url)).not_to have_been_made
          expect(a_request(:get, mask_url)).not_to have_been_made
        end
      end
    end

    describe "#save" do
      before do
        Dir.mkdir(tmpdir)
      end

      it "should save itself to the file" do
        image = described_class.new(image_name)
        image.save(tmpdir, filename)
        expect(File.exist?(File.join(tmpdir, filename))).to be_truthy
      end

      after do
        FileUtils.rm_rf(tmpdir)
      end
    end
  end
end
