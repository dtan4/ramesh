require "spec_helper"

module Ramesh
  describe Logger do
    let(:output) do
      double("output", puts: true)
    end

    let(:logger) do
      described_class.new(output)
    end

    describe "#info" do
      it "should flush message" do
        logger.info("message")
        expect(output).to have_received(:puts).with("message")
      end
    end
  end
end
