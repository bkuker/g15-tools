/*
This code taken from Paul Kimpel's retro-g15 Paper-Tape-Disassembler.html tool

Copyright (c) 2021 Paul Kimpel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */
import { g15Hex } from "./conversionUtils";

const two28 = 0x10000000;           // 2**28 for complementing word values
const longLineSize = 108;           // words per long drum line


export default function disassembleWord(loc, word) {
    /* Disassembles one block of words */
    let ch = "";                    // command characteristic interpretation
    let head = "";                  // left-hand fields
    let op = 0;                     // operand address (T or L+1)
    let sign = 0;                   // sign bit of current word
    let signCode = "";              // interpreted sign bit
    let signedValue = "";           // internal signed value of word
    let src = "";                   // source interpretation
    let dest = "";                  // destination interpretation
    let seq = "";                   // flag indicating whether next command is at this or next word
    let tail = "";                  // right-hand fields
    let locText = "";
    let timing = 0;                 // transfer state timing
    let value = 0;                  // magnitude of current word

    let p = 0;                      // prefix -- 0=immediate, 1=deferred
    let t = 0;                      // T -- timing number
    let bp = 0;                     // breakpoint bit
    let n = 0;                      // N -- next instruction location
    let c = 0;                      // characteristic
    let s = 0;                      // source line
    let d = 0;                      // destination line
    let dp = 0;                     // double-precision bit
    let cs = 0;                     // "via AR" flip flop
    let nL = 0;                     // drum location after transfer state

    value = word >> 1;
    sign = word & 1;
    signCode = (sign ? "-" : " ");
    signedValue = (sign ? -value : value);

    // Decode the instruction
    dp = word & 0x01;             // single/double mode
    d = (word >> 1) & 0x1F;      // destination line
    s = (word >> 6) & 0x1F;      // source line
    c = (word >> 11) & 0x03;     // characteristic code
    n = (word >> 13) & 0x7F;     // next command location
    bp = (word >> 20) & 0x01;     // breakpoint flag
    t = (word >> 21) & 0x7F;     // operand timing number
    p = (word >> 28) & 0x01;     // prefix (immediate/deferred execution) bit

    // Set "via AR" flip-flop (CX . S7/ . D7/)
    cs = (((word >> 12) & 1) && ((~(word >> 8)) & 7) && ((~(word >> 3)) & 7) ? 1 : 0);

    /*******************************************************************
    // Officially, L=107 is disqualified as a location for a command. The
    // reason is that location arithmetic is done using a 7-bit number (with
    // values 0-127) but the location following 107 is 0, not 108. The number
    // track (CN) normally handles this by increasing the N and (usually) T
    // numbers by 20 when passing location 107 to turn location 108 into
    // location 128, which in a 7-bit register is the same as zero. Alas,
    // this adjustment does not occur when a command is executed from
    // location 107, so N and (usually) T in the command will behave as if
    // they are 20 word-times too low. The following code adjusts T and N
    // so that they will behave as the hardware would have.

    if (loc == 127) {
        n = (n + 20 + longLineSize) % longLineSize;
        if (!(d == 31 && (s & 0b11100) == 0b11000)) {    // not 24-27: MUL, DIV, SHIFT, NORM
            t = (t + 20 + longLineSize) % longLineSize;
        }
    }
    *******************************************************************/

    head = loc.toString().padStart(2, "0") + " " + g15Hex(word).padStart(8, "0") + " " +
        signCode + g15Hex(value).padStart(7, "0") + " " +
        signedValue.toString().padStart(10, " ") + " " +
        signCode + (value / two28).toFixed(9) + " " +
        ("id").at(p) +
        t.toString().padStart(4, " ") +
        n.toString().padStart(4, " ") +
        (dp * 4 + c).toString().padStart(2, " ") +
        s.toString().padStart(3, " ") +
        d.toString().padStart(3, " ") +
        (dp ? "1" : "").padStart(2, " ") +
        (bp ? "b" : "").padStart(3, " ");

    // Now interpret that mess...


    locText = loc.toString().padStart(4, " ") + ": ";

    // Indicate immediate/deferred & single/double precision.
    tail = (p ? "d " : "i ") + (dp ? "DP-" : "");

    // Determine transfer characteristic.
    switch (c) {
        case 0:
            ch = "TR";
            break;
        case 1:
            ch = "AD";
            break;
        case 2:
            ch = (cs ? "TVA" : "AV");
            break;
        case 3:
            ch = (cs ? "AVA" : "SU");
            break;
        default:
            ch = `<C=${c} Invalid>`;
            break;
    }

    // Determine operand address and command timing.
    op = (p ? t : loc + 1);
    timing = (p ? dp + 1 : t - loc - 1);
    if (timing <= 0) {
        timing += longLineSize;
    }

    // Determine transfer source location.
    if (s < 24) {
        src = s.toString() + ":";
        if (s < 20) {
            src += op;
        } else {
            src += (op % 4);
        }
    } else if (s < 32) {
        switch (s) {
            case 24:
                src = "MQ:" + (op % 2);
                break;
            case 25:
                src = "ID:" + (op % 2);
                break;
            case 26:
                src = "PN:" + (op % 2);
                break;
            case 27:
                src = "(20.21+20/.AR):" + op % 4;
                break;
            case 28:
                src = "AR";
                break;
            case 29:
                src = "(20.IR):" + op % 4;
                break;
            case 30:
                src = "(20/.21):" + op % 4;
                break;
            case 31:
                src = "(20.21):" + op % 4;
                break;
            default:
                src = `<S=${s} Invalid>`;
                break;
        }
    }

    // Determine destination transfer location.
    if (d < 24) {
        dest = d.toString() + ":";
        if (d < 20) {
            dest += op.toString();
        } else {
            dest += (op % 4).toString();
        }
    } else if (d < 31) {
        switch (d) {
            case 24:
                dest = "MQ:" + (op % 2);
                break;
            case 25:
                dest = "ID:" + (op % 2);
                break;
            case 26:
                dest = "PN:" + (op % 2);
                break;
            case 27:
                dest = "TEST:" + op;
                break;
            case 28:
                dest = "AR";
                break;
            case 29:
                dest = "AR+";
                break;
            case 30:
                dest = "PN+:" + op % 2;
                break;
            default:
                dest = `<D=${d} Invalid>`;
                break;
        }
    } else if (d == 31) {
        switch (s) {
            case 0:
                dest = "SET I/O READY:" + op;
                break;
            case 1:
                dest = "MAG WRITE " + c + ":" + op;
                break;
            case 2:
                dest = "FAST PUNCH LEADER:" + op;
                break;
            case 3:
                dest = "FAST PUNCH 19:" + op;
                break;
            case 4:
                dest = "MAG SEARCH REV " + c + ":" + op;
                break;
            case 5:
                dest = "MAG SEARCH FWD " + c + ":" + op;
                break;
            case 6:
                dest = "PAPER TAPE REV1:" + op;
                break;
            case 7:
                dest = "PAPER TAPE REV2:" + op;
                break;
            case 8:
                dest = "TYPE AR:" + op;
                break;
            case 9:
                dest = "TYPE 19:" + op;
                break;
            case 10:
                dest = "PUNCH 19:" + op;
                break;
            case 11:
                dest = "CARD PUNCH 19:" + op;
                break;
            case 12:
                dest = "TYPE IN:" + op;
                break;
            case 13:
                dest = "MAG READ " + c + ":" + op;
                break;
            case 14:
                dest = "CARD READ:" + op;
                break;
            case 15:
                dest = "PAPER TAPE READ:" + op;
                break;
            case 16:
                dest = "HALT:" + op;
                break;
            case 17:
                dest = "RING BELL:" + op;
                switch (c) {
                    case 0:
                        break;          // just ring the bell
                    case 1:
                        dest += ", TEST MANUAL PUNCH";
                        break;
                    case 2:
                        dest += ", START IR";
                        break;
                    case 3:
                        dest += ", STOP IR";
                        break;
                    default:
                        dest += `<C=${c} Invalid>`;
                        break;
                }
                break;
            case 18:
                dest = "TR 20:" + op + ".ID" + (op % 2) + " > OR";
                break;
            case 19:
                dest = "DA-1 ";
                switch (c) {
                    case 0:
                        dest += "START";
                        break;
                    case 1:
                        dest += "STOP";
                        break;
                    default:
                        dest += `<C=${c} Invalid>`;
                        break;
                }

                dest += ":" + op;
                break;
            case 20:
                dest = "RETURN:" + op + ", CD=" + (dp * 4 + c);
                break;
            case 21:
                dest = "MARK:" + op + ", CD=" + (dp * 4 + c);
                if (p) {
                    timing = 1;             // deferred MARK ignores DP bit
                }
                break;
            case 22:
                dest = "TEST AR-SIGN";
                break;
            case 23:
                switch (c) {
                    case 0:
                        dest = "CLEAR MQ/ID/PN/IP:" + op;
                        break;
                    case 3:
                        dest = `TR PN:${(op % 2)}.2:${op} > ID, PN:${(op % 2)}.2/:${op} > PN`;
                        break;
                    default:
                        dest = `D23:${op} <C=${c} Invalid>`;
                        break;
                }
                break;
            case 24:
                dest = "MUL:" + op;
                timing = t;
                break;
            case 25:
                dest = "DIV:" + op;
                timing = t;
                if (c != 1) {
                    dest += " <ch != 1>";
                }
                break;
            case 26:
                dest = "SHIFT MQ-L/ID-R:" + op;
                timing = t;
                if (c == 0) {
                    dest += ", ++AR"
                } else if (c > 1) {
                    dest += " <ch=" + c + ">";
                }
                break;
            case 27:
                dest = "NORM MQ:" + op;
                timing = t;
                if (c == 0) {
                    dest += ", ++AR"
                } else if (c > 1) {
                    dest += " <ch=" + c + ">";
                }
                break;
            case 28:
                switch (c) {
                    case 0:
                        dest = "TEST I/O READY:" + op;
                        break;
                    case 1:
                        dest = "TEST READY IN:" + op;
                        break;
                    case 2:
                        dest = "TEST READY OUT:" + op;
                        break;
                    case 3:
                        dest = "TEST DA-1 OFF:" + op;
                        break;
                    default:
                        dest = `<S=28, C=${c} Invalid>`;
                        break;
                }
                break;
            case 29:
                dest = "TEST OVERFLOW:" + op;
                break;
            case 30:
                dest = "MAG FILE CODE " + c + ":" + op;
                break;
            case 31:
                switch (c) {
                    case 0:
                        dest = "NEXT CMD FROM AR:" + op;
                        break;
                    case 1:
                        dest = "TR NT+18 > 18:" + op;
                        break;
                    case 2:
                        dest = "TR 20+18 > 18:" + op;
                        break;
                    default:
                        dest = `S=31:${op} <C=${c} Invalid>`;
                        break;
                }
                break;
            default:
                dest = `<D=31 S=${s} Invalid>`;
                break;
        }
    } else {
        dest = `<D=${d} Invalid>`;
    }

    // Put it all together.
    seq = (n == loc || n == loc + 1 ? "" : "*");  // next is current or +1
    if (d < 31) {
        tail += `${ch} ${src} > ${dest}`;
    } else {
        tail += dest;
    }

    nL = (op + timing + longLineSize) % longLineSize;
    return {
        head,
        tail,
        butt: `${tail}${(p ? "" : " #" + timing)}`, //Forgive me
        full: `${head}${locText}${tail}${(p ? "" : " #" + timing)}, nL=${nL}, N=${n}${seq}`
    }


}