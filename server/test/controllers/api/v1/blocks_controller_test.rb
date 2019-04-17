require "test_helper"

module Api
  module V1
    class BlocksControllerTest < ActionDispatch::IntegrationTest
      test "should get success code when visit index" do
        valid_get api_v1_blocks_url

        assert_response :success
      end

      test "should set right content type when visit index" do
        valid_get api_v1_blocks_url

        assert_equal "application/vnd.api+json", response.content_type
      end

      test "should get serialized objects" do
        create(:block)
        blocks = Block.all

        valid_get api_v1_blocks_url

        assert_equal BlockSerializer.new(blocks).serialized_json, response.body
      end

      test "serialized objects should in reverse order of id" do
        create_list(:block, 2, :with_block_hash)

        valid_get api_v1_blocks_url

        first_block = json["data"].first
        last_block = json["data"].last

        assert_operator first_block["id"].to_i, :>, last_block["id"].to_i
      end

      test "should contain right keys in the serialized object" do
        create(:block)

        valid_get api_v1_blocks_url

        response_block = json["data"].first
        assert_equal %w(block_hash number transactions_count proposal_transactions_count uncles_count uncle_block_hashes reward total_transaction_fee cell_consumed total_cell_capacity miner_hash timestamp difficulty version nonce proof).sort, response_block["attributes"].keys.sort
      end

      test "should respond with 415 Unsupported Media Type when Content-Type is wrong" do
        get api_v1_blocks_url, headers: { "Content-Type": "text/plain" }

        assert_equal 415, response.status
      end

      test "should respond with error object when Content-Type is wrong" do
        error_object = Api::V1::Exceptions::WrongContentTypeError.new
        response_json = RequestErrorSerializer.new([error_object], message: error_object.title).serialized_json

        get api_v1_blocks_url, headers: { "Content-Type": "text/plain" }

        assert_equal response_json, response.body
      end

      test "should respond with 406 Not Acceptable when Accept is wrong" do
        get api_v1_blocks_url, headers: { "Content-Type": "application/vnd.api+json", "Accept": "application/json" }

        assert_equal 406, response.status
      end

      test "should respond with error object when Accept is wrong" do
        error_object = Api::V1::Exceptions::WrongAcceptError.new
        response_json = RequestErrorSerializer.new([error_object], message: error_object.title).serialized_json

        get api_v1_blocks_url, headers: { "Content-Type": "application/vnd.api+json", "Accept": "application/json" }

        assert_equal response_json, response.body
      end

      test "should return 10 records when page_size is not set" do
        create_list(:block, 15, :with_block_hash)

        valid_get api_v1_blocks_url

        assert_equal 10, json["data"].size
      end

      test "should return the corresponding number of blocks when set page_size" do
        create_list(:block, 15, :with_block_hash)

        valid_get api_v1_blocks_url, params: { page_size: 12 }

        assert_equal 12, json["data"].size
      end

      test "should return the corresponding blocks when set page" do
        create_list(:block, 15, :with_block_hash)
        block = Block.recent.offset(1).first
        parsed_block = JSON.parse(BlockSerializer.new(block).serialized_json)["data"]

        valid_get api_v1_blocks_url, params: { page: 2, page_size: 1 }

        assert_equal parsed_block, json["data"].first
      end

      test "should get success code when visit show" do
        block = create(:block)

        valid_get api_v1_block_url(block.block_hash)

        assert_response :success
      end

      test "should set right content type when visit show" do
        valid_get api_v1_block_url(1)

        assert_equal "application/vnd.api+json", response.content_type
      end

      test "should contain right keys in the serialized object when vist show" do
        block = create(:block)

        valid_get api_v1_block_url(block.block_hash)

        response_block = json["data"]
        assert_equal %w(block_hash number transactions_count proposal_transactions_count uncles_count uncle_block_hashes reward total_transaction_fee cell_consumed total_cell_capacity miner_hash timestamp difficulty version nonce proof).sort, response_block["attributes"].keys.sort
      end

      test "should respond with 415 Unsupported Media Type when Content-Type is wrong when vist show" do
        get api_v1_block_url(1), headers: { "Content-Type": "text/plain" }

        assert_equal 415, response.status
      end

      test "should respond with error object when Content-Type is wrong when vist show" do
        error_object = Api::V1::Exceptions::WrongContentTypeError.new
        response_json = RequestErrorSerializer.new([error_object], message: error_object.title).serialized_json

        get api_v1_block_url(1), headers: { "Content-Type": "text/plain" }

        assert_equal response_json, response.body
      end

      test "should respond with 406 Not Acceptable when Accept is wrong when vist show" do
        get api_v1_block_url(1), headers: { "Content-Type": "application/vnd.api+json", "Accept": "application/json" }

        assert_equal 406, response.status
      end

      test "should respond with error object when Accept is wrong when vist show" do
        error_object = Api::V1::Exceptions::WrongAcceptError.new
        response_json = RequestErrorSerializer.new([error_object], message: error_object.title).serialized_json

        get api_v1_block_url(1), headers: { "Content-Type": "application/vnd.api+json", "Accept": "application/json" }

        assert_equal response_json, response.body
      end

      test "should return error object when id is not a hex start with 0x" do
        error_object = Api::V1::Exceptions::BlockQueryKeyInvalidError.new
        response_json = RequestErrorSerializer.new([error_object], message: error_object.title).serialized_json

        valid_get api_v1_block_url("9034fwefwef")

        assert_equal response_json, response.body
      end

      test "should return error object when id is a hex start with 0x but the length is wrong" do
        error_object = Api::V1::Exceptions::BlockQueryKeyInvalidError.new
        response_json = RequestErrorSerializer.new([error_object], message: error_object.title).serialized_json

        valid_get api_v1_block_url("0xawefwef")

        assert_equal response_json, response.body
      end

      test "should return error object when no records found by id" do
        error_object = Api::V1::Exceptions::BlockNotFoundError.new
        response_json = RequestErrorSerializer.new([error_object], message: error_object.title).serialized_json

        valid_get api_v1_block_url("0.87")

        assert_equal response_json, response.body
      end

      test "should return corresponding block with given block hash" do
        block = create(:block)

        valid_get api_v1_block_url(block.block_hash)

        assert_equal JSON.parse(BlockSerializer.new(block).serialized_json), json
      end

      test "should return corresponding block with given height" do
        block = create(:block)

        valid_get api_v1_block_url(block.number)

        assert_equal JSON.parse(BlockSerializer.new(block).serialized_json), json
      end
    end
  end
end