from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
import base64  # for signing messages algorithms
from cryptography.exceptions import InvalidSignature  # Error message for verifying signed messages


def generate_private_key():
    """
    Using RSA encryption, generates a private key.
    :return:
    """
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )

    return private_key


def serialize_private_key(private_key):
    """
    Serialize (flattens) the private key as bytes to make it readable.
    :param private_key: Private RSA key generated.
    :return: Private key as bytes.
    """
    pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )

    with open('private_key.pem', 'wb') as f:
        f.write(pem)


def derive_public_key(private_key):
    """
    Using RSA encryption, derives the public key from the private key.
    :param private_key: Private RSA key generated.
    :return: Public key.
    """
    # derive the public key from the private key
    public_key = private_key.public_key()

    return public_key


def serialize_public_key(public_key):
    """
    Serialize (flattens) the public key as bytes to make it readable.
    :param public_key: Public RSA key derived from Private key.
    :return: Public key as bytes.
    """
    pem = public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    )

    with open('public_key.pem', 'wb') as f:
        f.write(pem)


def open_private_key():
    """
    Loads the private key from the .pem file.
    :return: Returns the private key from the .pem file.
    """
    with open('private_key.pem', 'rb') as f:
        private_key = serialization.load_pem_private_key(
            f.read(),
            password=None,
            backend=default_backend()
        )
    return private_key


def open_public_key():
    """
    Loads the public key from the .pem file.
    :return: Returns the public key from the .pem file.
    """
    with open('public_key.pem', 'rb') as f:
        public_key = serialization.load_pem_public_key(
            f.read(),
            backend=default_backend()
        )
    return public_key


def plain_text(msg="", t_format='utf-8'):
    """
    Gets the plain text message from the user and returns it as bytes in UTF-8 format.
    :param msg: Plain text message, default is empty.
    :param t_format: Text format, default is utf-8.
    :return: Plain text message as bytes in utf-8 formatting.
    """
    if msg == "":
        msg = input("Enter your plain text message to be encrypted: ")
    return bytes(msg, t_format)


def encrypt_msg(msg, public_key):
    """
    Encrypts the plain text message using the public key.
    :param public_key: Public RSA key.
    :param msg: The plain text message to encrypt.
    :return: Encrypted message using RSA.
    """
    ciphertext = public_key.encrypt(
        msg,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        ))

    return ciphertext


def decrypt_msg(cipher_txt, private_key, t_format='utf-8'):
    """
    Decrypts the cipher text message using the private key.
    :param t_format: Text format for returning the message as text, default is utf-8.
    :param cipher_txt: Encrypted cipher text to be decrypted.
    :param private_key: Private RSA key.
    :return: Decrypted message.
    """
    msg = private_key.decrypt(
        cipher_txt,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )

    return msg.decode(t_format)  # Decode the message from the bit array to plain text.


def sign_msg(msg, private_key):
    """
    Signs the message using the private key.
    Using the private key to sign the message. The sign() function returns the digital signature of the string.
    It returns the digital signature as a byte array, and get_digital_signature returns it as string using base64.
    :param msg: The plain text message to sign.
    :param private_key: Private RSA key.
    :return: Signed message using RSA encryption.
    """
    signed_msg = private_key.sign(
        msg,
        padding.PSS(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            salt_length=padding.PSS.MAX_LENGTH
        ),
        hashes.SHA256()
    )

    return signed_msg


def get_digital_signature(signed_msg, t_format='utf-8'):
    """
    Gets the signed message and returns it from base 64 format.
    Using base64 encoding to convert the signed message from bytes array to string.
    :param signed_msg: Message signed using RSA encryption, preferably from sign_msg function.
    :param t_format: Text format for returning the signed message as text, default is utf-8.
    :return: Signed message from base 64 format.
    """
    signed_base64 = base64.b64encode(signed_msg).decode(t_format)
    return signed_base64


def verify_signed_msg(signed_base64, public_key, msg):
    """
    Verifies the signed message using the public key. Tests if the sender has indeed sent it, and the message wasn't
    tampered with.
    :param signed_base64: Signed message decoded as base64 (string).
    :param public_key: Public RSA key.
    :param msg: Plain text original message.
    :return: Prompt (as str) if signed message is authentic [valid/invalid].
    """
    signed = base64.b64decode(signed_base64)
    try:
        public_key.verify(
            signed,
            msg,
            padding.PSS(
                mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.MAX_LENGTH
            ),
            hashes.SHA256()
        )
        return 'Signature is valid!'
    except InvalidSignature:
        return 'Signature is invalid!'


def main():
    private_key = generate_private_key()  # Generate a private key
    public_key = derive_public_key(private_key)  # Derive a public key from the private key
    serialize_private_key(private_key)  # Flatten the private key.
    serialize_public_key(public_key)  # Flatten the public key.
    msg = plain_text()  # Get the message as plain text from the user.
    cipher_text = encrypt_msg(msg=msg, public_key=public_key)  # Encrypt the message using the public key.
    print(decrypt_msg(cipher_txt=cipher_text, private_key=private_key))  # Print the decoded msg using the private key.
    signed_message = sign_msg(msg=msg, private_key=private_key)  # Sign the message using the private key.
    signed_base64 = get_digital_signature(signed_msg=signed_message)
    print(signed_base64)  # Print the signed message as strings using base64.
    print(verify_signed_msg(signed_base64=signed_base64, public_key=public_key, msg=msg))  # Checks if the signed message
    # is verified, using the public key.


if __name__ == "__main__":
    main()
