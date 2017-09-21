//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// RailFence cipher
const char *MakeRailFence(const char *plaintext, int size, int hight);
const char *Encipher(const char* railfence, int size);
const char *Decipher(const char* ciphertext, int hight);
const char *SaveSpecialSymbols(const char* text);
const char *ReturnSpecialSymbols(const char* text);

// Columns cipher
const char *ColumnEncipher(const char *plaintext, const char *keyword);
const char *GetColumns();
