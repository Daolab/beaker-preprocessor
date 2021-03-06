{-|
Module      : OpCode.Parser
Description : Parse for EVM bytecode
Copyright   : (c) Daolab 2018

Functionality for parsing EVM bytecode.
-}

-- Unused do binds are common in parsers, so we will allow them.
{-# OPTIONS_GHC -fno-warn-unused-do-bind #-}
module OpCode.Parser where

import OpCode.Type

import Prelude hiding (LT, EQ, GT)

import Control.Applicative
import Data.ByteString (pack)
import Data.Attoparsec.ByteString as A

-- |Parse some bytecode. This may be full contract or not. This also accounts
-- for Swarm metadata, which is not part of the EVM specification, but is
-- appended to a contract's bytecode when it is compiled from Solidity.
parseOpCodes :: Parser [OpCode]
parseOpCodes = manyTill parseOpCode (parseSwarmMetadata  <|> endOfInput)

-- |Parse a single op code.
parseOpCode :: Parser OpCode
parseOpCode = choice opCodeParserList <?> "opcode"

-- | A list of op code parsers.
opCodeParserList :: [Parser OpCode]
opCodeParserList =
    [ parseSTOP
    , parseADD
    , parseMUL
    , parseSUB
    , parseDIV
    , parseSDIV
    , parseMOD
    , parseSMOD
    , parseADDMOD
    , parseMULMOD
    , parseEXP
    , parseSIGNEXTEND
    , parseLT
    , parseGT
    , parseSLT
    , parseSGT
    , parseEQ
    , parseISZERO
    , parseAND
    , parseOR
    , parseXOR
    , parseNOT
    , parseBYTE
    , parseSHA3
    , parseADDRESS
    , parseBALANCE
    , parseORIGIN
    , parseCALLER
    , parseCALLVALUE
    , parseCALLDATALOAD
    , parseCALLDATASIZE
    , parseCALLDATACOPY
    , parseCODESIZE
    , parseCODECOPY
    , parseGASPRICE
    , parseEXTCODESIZE
    , parseEXTCODECOPY
    , parseRETURNDATASIZE
    , parseRETURNDATACOPY
    , parseBLOCKHASH
    , parseCOINBASE
    , parseTIMESTAMP
    , parseNUMBER
    , parseDIFFICULTY
    , parseGASLIMIT
    , parsePOP
    , parseMLOAD
    , parseMSTORE
    , parseMSTORE8
    , parseSLOAD
    , parseSSTORE
    , parseJUMP
    , parseJUMPI
    , parsePC
    , parseMSIZE
    , parseGAS
    , parseJUMPDEST
    , parsePUSH1
    , parsePUSH2
    , parsePUSH3
    , parsePUSH4
    , parsePUSH5
    , parsePUSH6
    , parsePUSH7
    , parsePUSH8
    , parsePUSH9
    , parsePUSH10
    , parsePUSH11
    , parsePUSH12
    , parsePUSH13
    , parsePUSH14
    , parsePUSH15
    , parsePUSH16
    , parsePUSH17
    , parsePUSH18
    , parsePUSH19
    , parsePUSH20
    , parsePUSH21
    , parsePUSH22
    , parsePUSH23
    , parsePUSH24
    , parsePUSH25
    , parsePUSH26
    , parsePUSH27
    , parsePUSH28
    , parsePUSH29
    , parsePUSH30
    , parsePUSH31
    , parsePUSH32
    , parseDUP1
    , parseDUP2
    , parseDUP3
    , parseDUP4
    , parseDUP5
    , parseDUP6
    , parseDUP7
    , parseDUP8
    , parseDUP9
    , parseDUP10
    , parseDUP11
    , parseDUP12
    , parseDUP13
    , parseDUP14
    , parseDUP15
    , parseDUP16
    , parseSWAP1
    , parseSWAP2
    , parseSWAP3
    , parseSWAP4
    , parseSWAP5
    , parseSWAP6
    , parseSWAP7
    , parseSWAP8
    , parseSWAP9
    , parseSWAP10
    , parseSWAP11
    , parseSWAP12
    , parseSWAP13
    , parseSWAP14
    , parseSWAP15
    , parseSWAP16
    , parseLOG0
    , parseLOG1
    , parseLOG2
    , parseLOG3
    , parseLOG4
    , parseCREATE
    , parseCALL
    , parseCALLCODE
    , parseRETURN
    , parseDELEGATECALL
    , parseSTATICCALL
    , parseREVERT
    , parseINVALID
    , parseSELFDESTRUCT
    ]


parseSTOP = word8 0x00 >> pure STOP <?> "STOP"
parseADD = word8 0x01 >> pure ADD <?> "ADD"
parseMUL = word8 0x02 >> pure MUL <?> "MUL"
parseSUB = word8 0x03 >> pure SUB <?> "SUB"
parseDIV = word8 0x04 >> pure DIV <?> "DIV"
parseSDIV = word8 0x05 >> pure SDIV <?> "SDIV"
parseMOD = word8 0x06 >> pure MOD <?> "MOD"
parseSMOD = word8 0x07 >> pure SMOD <?> "SMOD"
parseADDMOD = word8 0x08 >> pure ADDMOD <?> "ADDMOD"
parseMULMOD = word8 0x09 >> pure MULMOD <?> "MULMOD"
parseEXP = word8 0x0a >> pure EXP <?> "EXP"
parseSIGNEXTEND = word8 0x0b >> pure SIGNEXTEND <?> "SIGNEXTEND"

parseLT = word8 0x10 >> pure LT <?> "LT"
parseGT = word8 0x11 >> pure GT <?> "GT"
parseSLT = word8 0x12 >> pure SLT <?> "SLT"
parseSGT = word8 0x13 >> pure SGT <?> "SGT"
parseEQ = word8 0x14 >> pure EQ <?> "EQ"
parseISZERO = word8 0x15 >> pure ISZERO <?> "ISZERO"
parseAND = word8 0x16 >> pure AND <?> "AND"
parseOR = word8 0x17 >> pure OR <?> "OR"
parseXOR = word8 0x18 >> pure XOR <?> "XOR"
parseNOT = word8 0x19 >> pure NOT <?> "NOT"
parseBYTE = word8 0x1a >> pure BYTE <?> "BYTE"

parseSHA3 = word8 0x20 >> pure SHA3 <?> "SHA3"

parseADDRESS = word8 0x30 >> pure ADDRESS <?> "ADDRESS"
parseBALANCE = word8 0x31 >> pure BALANCE <?> "BALANCE"
parseORIGIN = word8 0x32 >> pure ORIGIN <?> "ORIGIN"
parseCALLER = word8 0x33 >> pure CALLER <?> "CALLER"
parseCALLVALUE = word8 0x34 >> pure CALLVALUE <?> "CALLVALUE"
parseCALLDATALOAD = word8 0x35 >> pure CALLDATALOAD <?> "CALLDATALOAD"
parseCALLDATASIZE = word8 0x36 >> pure CALLDATASIZE <?> "CALLDATASIZE"
parseCALLDATACOPY = word8 0x37 >> pure CALLDATACOPY <?> "CALLDATACOPY"
parseCODESIZE = word8 0x38 >> pure CODESIZE <?> "CODESIZE"
parseCODECOPY = word8 0x39 >> pure CODECOPY <?> "CODECOPY"
parseGASPRICE = word8 0x3a >> pure GASPRICE <?> "GASPRICE"
parseEXTCODESIZE = word8 0x3b >> pure EXTCODESIZE <?> "EXTCODESIZE"
parseEXTCODECOPY = word8 0x3c >> pure EXTCODECOPY <?> "EXTCODECOPY"
parseRETURNDATASIZE = word8 0x3d >> pure RETURNDATASIZE <?> "RETURNDATASIZE"
parseRETURNDATACOPY = word8 0x3e >> pure RETURNDATACOPY <?> "RETURNDATACOPY"

parseBLOCKHASH = word8 0x40 >> pure BLOCKHASH <?> "BLOCKHASH"
parseCOINBASE = word8 0x41 >> pure COINBASE <?> "COINBASE"
parseTIMESTAMP = word8 0x42 >> pure TIMESTAMP <?> "TIMESTAMP"
parseNUMBER = word8 0x43 >> pure NUMBER <?> "NUMBER"
parseDIFFICULTY = word8 0x44 >> pure DIFFICULTY <?> "DIFFICULTY"
parseGASLIMIT = word8 0x45 >> pure GASLIMIT <?> "GASLIMIT"

parsePOP = word8 0x50 >> pure POP <?> "POP"
parseMLOAD = word8 0x51 >> pure MLOAD <?> "MLOAD"
parseMSTORE = word8 0x52 >> pure MSTORE <?> "MSTORE"
parseMSTORE8 = word8 0x53 >> pure MSTORE8 <?> "MSTORE8"
parseSLOAD = word8 0x54 >> pure SLOAD <?> "SLOAD"
parseSSTORE = word8 0x55 >> pure SSTORE <?> "SSTORE"
parseJUMP = word8 0x56 >> pure JUMP <?> "JUMP"
parseJUMPI = word8 0x57 >> pure JUMPI <?> "JUMPI"
parsePC = word8 0x58 >> pure PC <?> "PC"
parseMSIZE = word8 0x59 >> pure MSIZE <?> "MSIZE"
parseGAS = word8 0x5a >> pure GAS <?> "GAS"
parseJUMPDEST = word8 0x5b >> pure JUMPDEST <?> "JUMPDEST"

parsePUSH1 = word8 0x60 >> PUSH1 <$> (fmap pack $ count 1 anyWord8) <?> "PUSH1"
parsePUSH2 = word8 0x61 >> PUSH2 <$> (fmap pack $ count 2 anyWord8) <?> "PUSH2"
parsePUSH3 = word8 0x62 >> PUSH3 <$> (fmap pack $ count 3 anyWord8) <?> "PUSH3"
parsePUSH4 = word8 0x63 >> PUSH4 <$> (fmap pack $ count 4 anyWord8) <?> "PUSH4"
parsePUSH5 = word8 0x64 >> PUSH5 <$> (fmap pack $ count 5 anyWord8) <?> "PUSH5"
parsePUSH6 = word8 0x65 >> PUSH6 <$> (fmap pack $ count 6 anyWord8) <?> "PUSH6"
parsePUSH7 = word8 0x66 >> PUSH7 <$> (fmap pack $ count 7 anyWord8) <?> "PUSH7"
parsePUSH8 = word8 0x67 >> PUSH8 <$> (fmap pack $ count 8 anyWord8) <?> "PUSH8"
parsePUSH9 = word8 0x68 >> PUSH9 <$> (fmap pack $ count 9 anyWord8) <?> "PUSH9"
parsePUSH10 = word8 0x69 >> PUSH10 <$> (fmap pack $ count 10 anyWord8) <?> "PUSH10"
parsePUSH11 = word8 0x6a >> PUSH11 <$> (fmap pack $ count 11 anyWord8) <?> "PUSH11"
parsePUSH12 = word8 0x6b >> PUSH12 <$> (fmap pack $ count 12 anyWord8) <?> "PUSH12"
parsePUSH13 = word8 0x6c >> PUSH13 <$> (fmap pack $ count 13 anyWord8) <?> "PUSH13"
parsePUSH14 = word8 0x6d >> PUSH14 <$> (fmap pack $ count 14 anyWord8) <?> "PUSH14"
parsePUSH15 = word8 0x6e >> PUSH15 <$> (fmap pack $ count 15 anyWord8) <?> "PUSH15"
parsePUSH16 = word8 0x6f >> PUSH16 <$> (fmap pack $ count 16 anyWord8) <?> "PUSH16"
parsePUSH17 = word8 0x70 >> PUSH17 <$> (fmap pack $ count 17 anyWord8) <?> "PUSH17"
parsePUSH18 = word8 0x71 >> PUSH18 <$> (fmap pack $ count 18 anyWord8) <?> "PUSH18"
parsePUSH19 = word8 0x72 >> PUSH19 <$> (fmap pack $ count 19 anyWord8) <?> "PUSH19"
parsePUSH20 = word8 0x73 >> PUSH20 <$> (fmap pack $ count 20 anyWord8) <?> "PUSH20"
parsePUSH21 = word8 0x74 >> PUSH21 <$> (fmap pack $ count 21 anyWord8) <?> "PUSH21"
parsePUSH22 = word8 0x75 >> PUSH22 <$> (fmap pack $ count 22 anyWord8) <?> "PUSH22"
parsePUSH23 = word8 0x76 >> PUSH23 <$> (fmap pack $ count 23 anyWord8) <?> "PUSH23"
parsePUSH24 = word8 0x77 >> PUSH24 <$> (fmap pack $ count 24 anyWord8) <?> "PUSH24"
parsePUSH25 = word8 0x78 >> PUSH25 <$> (fmap pack $ count 25 anyWord8) <?> "PUSH25"
parsePUSH26 = word8 0x79 >> PUSH26 <$> (fmap pack $ count 26 anyWord8) <?> "PUSH26"
parsePUSH27 = word8 0x7a >> PUSH27 <$> (fmap pack $ count 27 anyWord8) <?> "PUSH27"
parsePUSH28 = word8 0x7b >> PUSH28 <$> (fmap pack $ count 28 anyWord8) <?> "PUSH28"
parsePUSH29 = word8 0x7c >> PUSH29 <$> (fmap pack $ count 29 anyWord8) <?> "PUSH29"
parsePUSH30 = word8 0x7d >> PUSH30 <$> (fmap pack $ count 30 anyWord8) <?> "PUSH30"
parsePUSH31 = word8 0x7e >> PUSH31 <$> (fmap pack $ count 31 anyWord8) <?> "PUSH31"
parsePUSH32 = word8 0x7f >> PUSH32 <$> (fmap pack $ count 32 anyWord8) <?> "PUSH32"

parseDUP1 = word8 0x80 >> pure DUP1 <?> "DUP1"
parseDUP2 = word8 0x81 >> pure DUP2 <?> "DUP2"
parseDUP3 = word8 0x82 >> pure DUP3 <?> "DUP3"
parseDUP4 = word8 0x83 >> pure DUP4 <?> "DUP4"
parseDUP5 = word8 0x84 >> pure DUP5 <?> "DUP5"
parseDUP6 = word8 0x85 >> pure DUP6 <?> "DUP6"
parseDUP7 = word8 0x86 >> pure DUP7 <?> "DUP7"
parseDUP8 = word8 0x87 >> pure DUP8 <?> "DUP8"
parseDUP9 = word8 0x88 >> pure DUP9 <?> "DUP9"
parseDUP10 = word8 0x89 >> pure DUP10 <?> "DUP10"
parseDUP11 = word8 0x8a >> pure DUP11 <?> "DUP11"
parseDUP12 = word8 0x8b >> pure DUP12 <?> "DUP12"
parseDUP13 = word8 0x8c >> pure DUP13 <?> "DUP13"
parseDUP14 = word8 0x8d >> pure DUP14 <?> "DUP14"
parseDUP15 = word8 0x8e >> pure DUP15 <?> "DUP15"
parseDUP16 = word8 0x8f >> pure DUP16 <?> "DUP16"
parseSWAP1 = word8 0x90 >> pure SWAP1 <?> "SWAP1"
parseSWAP2 = word8 0x91 >> pure SWAP2 <?> "SWAP2"
parseSWAP3 = word8 0x92 >> pure SWAP3 <?> "SWAP3"
parseSWAP4 = word8 0x93 >> pure SWAP4 <?> "SWAP4"
parseSWAP5 = word8 0x94 >> pure SWAP5 <?> "SWAP5"
parseSWAP6 = word8 0x95 >> pure SWAP6 <?> "SWAP6"
parseSWAP7 = word8 0x96 >> pure SWAP7 <?> "SWAP7"
parseSWAP8 = word8 0x97 >> pure SWAP8 <?> "SWAP8"
parseSWAP9 = word8 0x98 >> pure SWAP9 <?> "SWAP9"
parseSWAP10 = word8 0x99 >> pure SWAP10 <?> "SWAP10"
parseSWAP11 = word8 0x9a >> pure SWAP11 <?> "SWAP11"
parseSWAP12 = word8 0x9b >> pure SWAP12 <?> "SWAP12"
parseSWAP13 = word8 0x9c >> pure SWAP13 <?> "SWAP13"
parseSWAP14 = word8 0x9d >> pure SWAP14 <?> "SWAP14"
parseSWAP15 = word8 0x9e >> pure SWAP15 <?> "SWAP15"
parseSWAP16 = word8 0x9f >> pure SWAP16 <?> "SWAP16"

parseLOG0 = word8 0xa0 >> pure LOG0 <?> "LOG0"
parseLOG1 = word8 0xa1 >> pure LOG1 <?> "LOG1"
parseLOG2 = word8 0xa2 >> pure LOG2 <?> "LOG2"
parseLOG3 = word8 0xa3 >> pure LOG3 <?> "LOG3"
parseLOG4 = word8 0xa4 >> pure LOG4 <?> "LOG4"

parseCREATE = word8 0xf0 >> pure CREATE <?> "CREATE"
parseCALL = word8 0xf1 >> pure CALL <?> "CALL"
parseCALLCODE = word8 0xf2 >> pure CALLCODE <?> "CALLCODE"
parseRETURN = word8 0xf3 >> pure RETURN <?> "RETURN"
parseDELEGATECALL = word8 0xf4 >> pure DELEGATECALL <?> "DELEGATECALL"
parseSTATICCALL = word8 0xfa >> pure STATICCALL <?> "STATICCALL"
parseREVERT = word8 0xfd >> pure REVERT <?> "REVERT"
parseINVALID = word8 0xfe >> pure INVALID <?> "INVALID"
parseSELFDESTRUCT = word8 0xff >> pure SELFDESTRUCT <?> "SELFDESTRUCT"

-- |Parse the Swarm metadata
-- http://solidity.readthedocs.io/en/v0.4.21/metadata.html#encoding-of-the-metadata-hash-in-the-bytecode.
-- This is a series of bytes surrounding a 32 byte
parseSwarmMetadata = do
    word8 0xa1
    word8 0x65
    word8 0x62
    word8 0x7a
    word8 0x7a
    word8 0x72
    word8 0x30
    word8 0x58
    word8 0x20
    count 32 anyWord8
    word8 0x00
    word8 0x29
    pure ()
    <?> "swarm metadata"
