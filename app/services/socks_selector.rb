class SocksSelector
  include Service

  def initialize(tags, pageNum, pageSize, order)
    @tags = tags
    @pageNum = pageNum
    @pageSize = pageSize
    @order = order
  end

  def call
    @socks = @tags.empty? ? Sock.all : Sock.all.filter{
      |sock| @tags.find{|tag| tag == Tag.find_by(tag_id: SockTag.find_by(sock_id: sock.sock_id).tag_id).name}
    }
    if !@pageSize.nil?
      @socks = @socks.slice((@pageNum-1)*@pageSize.to_i, @pageSize) || []
    end
    return @socks.map{|sock| {
      "id": sock.sock_id,
      "name": sock.name,
      "description": sock.description,
      "price": sock.price,
      "count": sock.count,
      "imageUrl": [sock.image_url_1, sock.image_url_2]
    }}
  end

end