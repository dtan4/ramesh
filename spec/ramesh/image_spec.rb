require "spec_helper"
require "fileutils"

module Ramesh
  describe Image do
    let(:image_name) { "201405091845" }
    let(:filename)   { "201405091845.jpg" }
    let(:tmpdir)     { File.expand_path(File.join("..", "..", "tmp"), __FILE__) }

    let(:mesh_url) do
      "http://tokyo-ame.jwa.or.jp/mesh/000/#{image_name}.gif"
    end

    let(:mesh_url_large) do
      "http://tokyo-ame.jwa.or.jp/mesh/100/#{image_name}.gif"
    end

    let(:background_url) do
      "http://tokyo-ame.jwa.or.jp/map/map000.jpg"
    end

    let(:background_url_large) do
      "http://tokyo-ame.jwa.or.jp/map/map100.jpg"
    end

    let(:mask_url) do
      "http://tokyo-ame.jwa.or.jp/map/msk000.png"
    end

    let(:mask_url_large) do
      "http://tokyo-ame.jwa.or.jp/map/msk100.png"
    end

    let(:fixture_image) do
      open(fixture_path("lena.png")).read
    end

    before do
      stub_request(:get, mesh_url)
        .to_return(status: 200, body: fixture_image)
      stub_request(:get, mesh_url_large)
        .to_return(status: 200, body: fixture_image)
      stub_request(:get, background_url)
        .to_return(status: 200, body: fixture_image)
      stub_request(:get, background_url_large)
        .to_return(status: 200, body: fixture_image)
      stub_request(:get, mask_url)
        .to_return(status: 200, body: fixture_image)
      stub_request(:get, mask_url_large)
        .to_return(status: 200, body: fixture_image)
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
