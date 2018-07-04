require 'spec_helper'

describe User do

  subject {
    described_class.new(email: "foo@bar.com", password: "password", permission_level: 0)
  }

  describe '#email' do
    it 'should not allow blank' do
      subject.email = nil

      expect(subject).to_not be_valid
    end

    it 'should require at symbol' do
      subject.email = 'example.com'

      expect(subject).to_not be_valid
    end

    it 'should require dot' do
      subject.email = 'user@com'

      expect(subject).to_not be_valid
    end

    it 'should not be obviously fake' do
      subject.email = 'a@b.c'

      expect(subject).to_not be_valid
    end

    it 'should have a real email' do
      subject.email = 'user@example.com'

      expect(subject).to be_valid
    end
  end

  describe '#password' do
    it 'should not allow blank' do
      u = User.new(email: 'user@example.com', password: '')

      expect(u).to_not be_valid
    end

    it 'should not allow short' do

    end
  end
end