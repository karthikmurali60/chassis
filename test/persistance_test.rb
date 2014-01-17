require_relative "test_helper"

class PersistanceTest < MiniTest::Unit::TestCase
  class FakeRepo

  end

  class Model
    include Chassis::Persistance

    class << self
      def repo
        FakeRepo
      end
    end
  end

  def test_models_can_be_initialize_with_a_hash
    model = Model.new id: 5
    assert_equal 5, model.id
  end

  def test_models_can_be_initialized_with_a_block
    model = Model.new do |model|
      model.id = 5
    end
    assert_equal 5, model.id
  end

  def test_class_has_a_create_factory
    FakeRepo.expects(:save)
    Model.create id: 5
  end

  def test_delegates_save_to_the_repo
    model = Model.new id: 5
    FakeRepo.expects(:save).with(model)
    model.save
  end

  def test_delegates_delete_to_the_repo
    model = Model.new id: 5
    FakeRepo.expects(:delete).with(model)
    model.delete
  end

  def test_is_new_record_when_id_is_nil
    model = Model.new id: 5
    refute model.new_record?

    model.id = nil
    assert model.new_record?
  end

  def test_implements_double_equals
    m1 = Model.new(id: 1)
    m2 = Model.new(id: 2)
    m3 = Model.new(id: 1)

    assert (m1 == m1)
    assert (m1 == m3)
    refute (m1 == m2)
  end

  def test_implements_triple_equals
    m1 = Model.new(id: 1)
    m2 = Model.new(id: 2)
    m3 = Model.new(id: 1)

    assert (m1 === m1)
    assert (m1 === m3)
    refute (m1 === m2)
  end

  def test_implements_eql?
    m1 = Model.new(id: 1)
    m2 = Model.new(id: 2)
    m3 = Model.new(id: 1)

    assert (m1 == m1)
    assert (m1 == m3)
    refute (m1 == m2)
  end

  def test_acts_has_a_hash_key
    m1 = Model.new(id: 1)
    m2 = Model.new(id: 2)
    m3 = Model.new(id: 1)

    hash = { }
    hash[m1] = 'm1'

    assert_includes hash, m1
    assert_includes hash, m3
    refute_includes hash, m2
  end

  def test_acts_well_in_arrays
    m1 = Model.new(id: 1)
    m2 = Model.new(id: 2)
    m3 = Model.new(id: 1)

    array = [ m1 ]

    assert_includes array, m1
    assert_includes array, m3
    refute_includes array, m2
  end
end
