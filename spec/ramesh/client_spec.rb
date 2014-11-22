require "spec_helper"
require "fileutils"

module Ramesh
  describe Client do
    let(:logger) { double("logger", info: true) }
    let(:client) { Ramesh::Client.new(logger) }
    let(:tmpdir) { File.expand_path(File.join("..", "..", "tmp"), __FILE__) }
    let(:meshes_index_url) { "http://tokyo-ame.jwa.or.jp/scripts/mesh_index.js" }

    before do
      stub_request(:get, meshes_index_url)
        .to_return(status: 200, body: open(fixture_path("index.js")))
      Dir.mkdir(tmpdir)
    end

    describe "#download_image" do
      let(:download_image) { client.download_image(minute, tmpdir, filename) }
      let(:minute)         { 0 }
      let(:filename)       { nil }

      before do
        image = double(write: true)
        allow_any_instance_of(Image).to receive(:download_image).and_return(image)
        allow_any_instance_of(Image).to receive(:composite_images).and_return(image)
      end

      context "when valid minute is specified" do
        let(:minute) do
          30
        end

        it "should return image name" do
          expect(download_image).to eq "201405091815.jpg"
        end

        it "should download the image of the specified minutes ago" do
          expect_any_instance_of(Image).to receive(:save).with(tmpdir, "201405091815.jpg").once
          download_image
        end

        it "should log the result" do
          expect(logger).to receive(:info).with("Downloaded: 201405091815.jpg")
          download_image
        end
      end

      context "when invalid minute is specified" do
        let(:minute) do
          7
        end

        it "should raise ArgumentError" do
          expect do
            download_image
          end.to raise_error ArgumentError
        end
      end

      context "when filename is specified" do
        let(:filename) do
          "out.jpg"
        end

        it "should return image name" do
          expect(download_image).to eq filename
        end

        it "should download the image with specified name" do
          expect_any_instance_of(Image).to receive(:save).with(tmpdir, "out.jpg").once
          download_image
        end
      end
    end

    describe "#download_large_image" do
      let(:download_large_image) { client.download_large_image(minute, tmpdir, filename) }
      let(:minute)               { 0 }
      let(:filename)             { nil }

      before do
        image = double(write: true)
        allow_any_instance_of(Image).to receive(:download_image).and_return(image)
        allow_any_instance_of(Image).to receive(:composite_images).and_return(image)
      end

      context "when valid minute is specified" do
        let(:minute) { 30 }

        it "should return image name" do
          expect(download_large_image).to eq "201405091815.jpg"
        end

        it "should download the image of the specified minutes ago" do
          expect_any_instance_of(Image).to receive(:save).with(tmpdir, "201405091815.jpg").once
          download_large_image
        end

        it "should log the result" do
          expect(logger).to receive(:info).with("Downloaded: 201405091815.jpg")
          download_large_image
        end
      end

      context "when invalid minute is specified" do
        let(:minute) { 7 }

        it "should raise ArgumentError" do
          expect do
            download_large_image
          end.to raise_error ArgumentError
        end
      end

      context "when filename is specified" do
        let(:filename) { "out.jpg" }

        it "should return image name" do
          expect(download_large_image).to eq filename
        end

        it "should download the image with specified name" do
          expect_any_instance_of(Image).to receive(:save).with(tmpdir, "out.jpg").once
          download_large_image
        end
      end
    end

    describe "#download_sequential_images" do
      let(:download_sequential_images) { client.download_sequential_images(from, to, tmpdir) }

      before do
        image = double(write: true)
        allow_any_instance_of(Image).to receive(:download_image).and_return(image)
        allow_any_instance_of(Image).to receive(:composite_images).and_return(image)
      end

      context "when valid section is specified" do
        let(:from) { 0 }
        let(:to)   { 30 }

        it "should return the array of image names" do
          result = download_sequential_images
          expect(result).to be_a Array
          expect(result.length).to eq 7
        end

        it "should download the images" do
          expect_any_instance_of(Client).to receive(:download_image).exactly(7).times
          download_sequential_images
        end
      end

      context "when invalid section is specified" do
        let(:from) { 1 }
        let(:to)   { 2 }

        it "should raise ArgumentError" do
          expect do
            download_sequential_images
          end.to raise_error ArgumentError
        end
      end
    end

    after do
      FileUtils.rm_rf(tmpdir)
    end
  end
end
