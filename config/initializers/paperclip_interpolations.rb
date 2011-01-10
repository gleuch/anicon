
# Switch to id partitioning for "new" paperclip uploads, so we don't have to move old ones (yet)
# DEPRECATEME!
Paperclip.interpolates(:id_smart) do |attachment, style|
  limit = 33600
  if attachment.instance.id > limit
    id_partition(attachment, style)
  else
    id(attachment, style)
  end    
end


# Fix for no method `fingerprint` in 3.0.2 / 3.0.3  >> https://github.com/thoughtbot/paperclip/issues/issue/346
if defined? ActionDispatch::Http::UploadedFile
  ActionDispatch::Http::UploadedFile.send(:include, Paperclip::Upfile)
end
