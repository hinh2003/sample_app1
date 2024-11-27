# frozen_string_literal: true

# This migration comes from active_storage (originally 20170806125915)
class CreateActiveStorageTables < ActiveRecord::Migration[5.2]
  def change
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    create_active_storage_blobs(primary_key_type)
    create_active_storage_attachments(foreign_key_type)
    create_active_storage_variant_records(foreign_key_type)
  end

  private

  def primary_and_foreign_key_types
    config = Rails.configuration.generators
    setting = config.options[config.orm][:primary_key_type]
    primary_key_type = setting || :primary_key
    foreign_key_type = setting || :bigint
    [primary_key_type, foreign_key_type]
  end

  def create_active_storage_blobs(primary_key_type)
    create_table :active_storage_blobs, id: primary_key_type do |t|
      add_blob_columns(t)
    end
    add_active_storage_blobs_index
  end

  def add_blob_columns(_table)
    _table.string   :key,          null: false
    _table.string   :filename,     null: false
    _table.string   :content_type
    _table.text     :metadata
    _table.string   :service_name, null: false
    _table.bigint   :byte_size,    null: false
    _table.string   :checksum,     null: false
    _table.datetime :created_at,   null: false
  end

  def add_active_storage_blobs_index
    add_index :active_storage_blobs, [:key], unique: true
  end

  def create_active_storage_attachments(foreign_key_type)
    create_table :active_storage_attachments, id: foreign_key_type do |t|
      add_attachment_columns(t, foreign_key_type)
    end
    add_active_storage_attachments_index
    add_foreign_key_for_attachments
  end

  def add_attachment_columns(_table, foreign_key_type)
    _table.string     :name,     null: false
    _table.references :record,   null: false, polymorphic: true, index: false, type: foreign_key_type
    _table.references :blob,     null: false, type: foreign_key_type
    _table.datetime :created_at, null: false
  end

  def add_active_storage_attachments_index
    add_index :active_storage_attachments, %i[record_type record_id name blob_id],
              name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  def add_foreign_key_for_attachments
    add_foreign_key :active_storage_attachments, :active_storage_blobs, column: :blob_id
  end

  def create_active_storage_variant_records(foreign_key_type)
    create_table :active_storage_variant_records, id: foreign_key_type do |t|
      add_variant_record_columns(t, foreign_key_type)
    end
    add_active_storage_variant_records_index
    add_foreign_key_for_variant_records
  end

  def add_variant_record_columns(_table, foreign_key_type)
    _table.belongs_to :blob, null: false, index: false, type: foreign_key_type
    _table.string :variation_digest, null: false
  end

  def add_active_storage_variant_records_index
    add_index :active_storage_variant_records, %i[blob_id variation_digest],
              name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  def add_foreign_key_for_variant_records
    add_foreign_key :active_storage_variant_records, :active_storage_blobs, column: :blob_id
  end
end
