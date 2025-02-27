class Block
  attr_reader :index, :timestamp, :transactions, 
              :transactions_count, :previous_hash, 
              :nonce, :hash, :miner  # Agregamos :miner

  def initialize(index, transactions, previous_hash, miner)
    @index          = index
    @timestamp      = Time.now
    @transactions   = transactions
    @transactions_count  = transactions.size
    @previous_hash  = previous_hash
    @miner         = miner  # Se almacena el nombre del minero
    @nonce, @hash  = compute_hash_with_proof_of_work
  end

  def compute_hash_with_proof_of_work(difficulty="00")
    nonce = 0
    loop do 
      hash = calc_hash_with_nonce(nonce)
      if hash.start_with?(difficulty)
        return [nonce, hash]
      else
        nonce +=1
      end
    end
  end
  
  def calc_hash_with_nonce(nonce=0)
    sha = Digest::SHA256.new
    sha.update( nonce.to_s + 
                @index.to_s + 
                @timestamp.to_s + 
                @transactions.to_s + 
                @transactions_count.to_s + 
                @previous_hash.to_s +
                @miner.to_s )
    sha.hexdigest 
  end

  def self.first(*transactions)
    Block.new(0, transactions, "0", "Satoshi")
  end

  def self.next(previous, transactions, miner)
    Block.new(previous.index + 1, transactions, previous.hash, miner)
  end
end  # class Block
