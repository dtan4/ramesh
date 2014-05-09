require 'spec_helper'

module Ramesh
  describe ImageUtil do
    include Ramesh::ImageUtil

    describe "#create_moment_image" do
      before(:all) do
        current_time = Time.now
        year = current_time.year
        month = current_time.month
        day = current_time.day
        hour = current_time.hour

        @gif = sprintf('%04d%02d%02d%02d00.gif', year, month, day, hour)
        create_moment_image(@gif)
      end

      context "downloaded image" do
        it "should exist" do
          expect(File.exist?(@gif)).to be_true
        end
      end

      after(:all) do
        File.delete(@gif) if File.exists?(@gif)
      end
    end
  end
end
