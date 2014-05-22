require "spec_helper"
require "fileutils"

module Ramesh
  describe Client do
    let(:client) do
      Ramesh::Client.new
    end

    let(:tmpdir) do
      File.expand_path(File.join("..", "..", "tmp"), __FILE__)
    end

    let(:meshes_index_url) do
      "http://tokyo-ame.jwa.or.jp/scripts/mesh_index.js"
    end

    before do
      stub_request(:get, meshes_index_url)
        .to_return(status: 200, body: open(fixture_path("index.js")))
      Dir.mkdir(tmpdir)
    end

    describe "#download_image" do
      before do
        image = double(write: true)
        Image.stub(download_image: image)
        Image.any_instance.stub(composite_images: image)
      end

      context "when minute is not specified" do
        it "should download the current image" do
          expect_any_instance_of(Image).to receive(:save).with(tmpdir, "201405091845").once
          client.download_image(tmpdir)
        end
      end

      context "when valid minute is specified" do
        it "should download the image of the specified minutes ago" do
          expect_any_instance_of(Image).to receive(:save).with(tmpdir, "201405091815").once
          client.download_image(tmpdir, 30)
        end
      end

      context "when invalid minute is specified" do
        it "should raise ArgumentError" do
          expect do
            client.download_image(tmpdir, 7)
          end.to raise_error ArgumentError
        end
      end
    end

    after do
      FileUtils.rm_rf(tmpdir)
    end
  end
end
