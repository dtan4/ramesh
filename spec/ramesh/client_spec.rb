require "spec_helper"
require "fileutils"

module Ramesh
  describe Client do
    let(:logger) do
      double("logger", info: true)
    end

    let(:client) do
      Ramesh::Client.new(logger)
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
        allow(Image).to receive(:download_image).and_return(image)
        allow_any_instance_of(Image).to receive(:composite_images).and_return(image)
      end

      context "when minute is not specified" do
        it "should download the current image" do
          expect_any_instance_of(Image).to receive(:save).with(tmpdir, "201405091845.jpg").once
          client.download_image(tmpdir)
        end

        it "should log the result" do
          expect(logger).to receive(:info).with("Downloaded: 201405091845.jpg")
          client.download_image(tmpdir)
        end
      end

      context "when valid minute is specified" do
        it "should download the image of the specified minutes ago" do
          expect_any_instance_of(Image).to receive(:save).with(tmpdir, "201405091815.jpg").once
          client.download_image(tmpdir, 30)
        end

        it "should log the result" do
          expect(logger).to receive(:info).with("Downloaded: 201405091815.jpg")
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

    describe "#download_sequential_images" do
      context "when valid section is specified" do
        it "should download the images" do
          expect_any_instance_of(Client).to receive(:download_image).exactly(7).times
          client.download_sequential_images(tmpdir, 0, 30)
        end
      end

      context "when invalid section is specified" do
        it "should raise ArgumentError" do
          expect do
            client.download_sequential_images(tmpdir, 1, 2)
          end.to raise_error ArgumentError
        end
      end
    end

    after do
      FileUtils.rm_rf(tmpdir)
    end
  end
end
