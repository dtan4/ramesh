require 'spec_helper'

describe Util do
  include Util

  describe '#extract_filename' do
    context 'http://tokyo-ame.jwa.or.jp/map/map000.jpg' do
      it 'returns "map000.jpg"' do
        extract_filename('http://tokyo-ame.jwa.or.jp/map/map000.jpg').should == 'map000.jpg'
      end
    end

    context 'http://tokyo-ame.jwa.or.jp/map/' do
      it 'returns ""' do
        extract_filename('http://tokyo-ame.jwa.or.jp/map/').should == ''
      end
    end
  end
end
