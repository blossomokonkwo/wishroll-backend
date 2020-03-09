if @topics.present?
    json.topics @topics.each do |topic|
        cache topic, expires_in: 1.hour do 
            json.title topic.title
            json.is_hot_topic topic.hot_topic
            json.media_url url_for(topic.topic_image) if topic.topic_image.attached?
            json.created_at topic.created_at
        end
    end
end
if @hot_topics.present?
    json.hot_topics @hot_topics.each do |hot_topic|
        cache hot_topic, expires_in: 1.hour do
            json.title hot_topic.title
            json.is_hot_topic hot_topic.hot_topic
            json.media_url url_for(hot_topic.topic_image) if hot_topic.topic_image.attached?
            json.created_at hot_topic.created_at
        end
    end
end