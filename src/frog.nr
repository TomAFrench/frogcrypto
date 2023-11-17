use dep::std::hash::poseidon::bn254 as poseidon;
use dep::std::eddsa::eddsa_poseidon_verify;

struct Frog {
    id: Field,
    biome: Field,
    rarity: Field,
    temperament: Field,
    jump: Field,
    speed: Field,
    intelligence: Field,
    beauty: Field,
    timestamp_signed: Field,
    owner_semaphore_id: Field,
    reserved_field1: Field,
    reserved_field2: Field,
    reserved_field3: Field,
}

impl Frog {
    fn is_valid(
        self,
        signer_pubkey_A_x: Field,
        signer_pubkey_A_y: Field,
        signature_s: Field,
        signature_r8_x: Field,
        signature_r8_y: Field
    ) -> bool {
        eddsa_poseidon_verify(
            signer_pubkey_A_x,
            signer_pubkey_A_y,
            signature_s,
            signature_r8_x,
            signature_r8_y,
            self.message_hash(),
        )
    }

    fn message_hash(self) -> Field {
        poseidon::hash_13([
            self.id,
            self.biome,
            self.rarity,
            self.temperament,
            self.jump,
            self.speed,
            self.intelligence,
            self.beauty,
            self.timestamp_signed,
            self.owner_semaphore_id,
            self.reserved_field1,
            self.reserved_field2,
            self.reserved_field3,
        ])
    }
}