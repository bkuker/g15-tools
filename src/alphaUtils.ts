////////////////////////////////
//   WARNING
//
// This code generated from a blurry pdf by the
// gippity clanker. Don't trust it.
//

// Lookup: character → numeric code (in hex, for readability)
const charToCode: Record<string, number> = {
    // Lowercase
    '0': 0xC0,
    '1': 0xC1,
    '2': 0xC2,
    '3': 0xC3,
    '4': 0xC4,
    '5': 0xC5,
    '6': 0xC6,
    '7': 0xC7,
    '8': 0xC8,
    '9': 0xC9,
    '=': 0xCB,
    '+': 0xD0,
    'a': 0xD1,
    'b': 0xD2,
    'c': 0xD3,
    'd': 0xD4,
    'e': 0xD5,
    'f': 0xD6,
    'g': 0xD7,
    'h': 0xD8,
    'i': 0xD9,


'>': 0xda,    
'.': 0xdb,
')': 0xdc,
';': 0xdd,
'^': 0xde,

    '-': 0xE0,
    'j': 0xE1,
    'k': 0xE2,
    'l': 0xE3,
    'm': 0xE4,
    'n': 0xE5,
    'o': 0xE6,
    'p': 0xE7,
    'q': 0xE8,
    'r': 0xE9,
    '\r': 0xEA,   // Carriage Return
    '$': 0xEB,
    '*': 0xEC,
    '\t': 0xED,   // Tab
    '°': 0xf0,
    '/': 0xf1,
    's': 0xf2,
    't': 0xf3,
    'u': 0xf4,
    'v': 0xf5,
    'w': 0xf6,
    'x': 0xf7,
    'y': 0xf8,
    'z': 0xf9,
    ',': 0xfb,
    '(': 0xfc,
    ' ': 0xfd, //space
    //'~': 0xff, //delete 
    // Uppercase
    '→': 0x81,
    '—': 0x83,
    '≠': 0x86,
    '[': 0x87,
    ']': 0x88,
    'A': 0x91,
    'B': 0x92,
    'C': 0x93,
    'D': 0x94,
    'E': 0x95,
    'F': 0x96,
    'G': 0x97,
    'H': 0x98,
    'I': 0x99,
    '<': 0x9A,
    '?': 0x9B,
    ':': 0x9D,
    '⌄': 0x9E,
    'J': 0xA1,
    'K': 0xA2,
    'L': 0xA3,
    'M': 0xA4,
    'N': 0xA5,
    'O': 0xA6,
    'P': 0xA7,
    'Q': 0xA8,
    'R': 0xA9,


    'S': 0xb2,
    'T': 0xb3,
    'U': 0xb4,
    'V': 0xb5,
    'W': 0xb6,
    'X': 0xb7,
    'Y': 0xb8,
    'Z': 0xb9,
    '|': 0xbb //What is this

};

// Reverse lookup: numeric code → character
const codeToChar: Record<number, string> = Object.fromEntries(
    Object.entries(charToCode).map(([char, code]) => [code, char])
);

// Convert character → numeric code
export function charToNumeric(ch: string): number | undefined {
    return charToCode[ch];
}

// Convert numeric code → character
export function numericToChar(code: number): string | undefined {
    return codeToChar[code];
}

// Encode full string → array of numeric codes
export function stringToCodes(str: string): number[] {
    return [...str].map(c => charToNumeric(c) ?? 0);
}

// Decode numeric codes → string
export function codesToString(codes: number[]): string {
    return codes.map(c => numericToChar(c) ?? '?').join('');
}
