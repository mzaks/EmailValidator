//
//  EmailValidatorTests.swift
//  EmailValidatorTests
//
//  Created by Evan Robertson on 27/11/17.
//  Copyright © 2017 Evan Robertson. All rights reserved.
//

import XCTest
import EmailValidator
@testable import EmailValidator

class EmailValidatorTests: XCTestCase {

    static var digits: String = "1234567890"
    static var letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static var atomCharacters: String = "!#$%&'*+-/=?^_`{|}~"

    var digitLettersAtomCharacterSet: CharacterSet!

    static var validAddresses: [String] = [
        "\"Abc\\@def\"@example.com",
        "\"Fred Bloggs\"@example.com",
        "\"Joe\\\\Blow\"@example.com",
        "\"Abc@def\"@example.com",
        "customer/department=shipping@example.com",
        "$A12345@example.com",
        "!def!xyz%abc@example.com",
        "_somename@example.com",
        "valid.ipv4.addr@[123.1.72.10]",
        "valid.ipv6.addr@[IPv6:0::1]",
        "valid.ipv6.addr@[IPv6:2607:f0d0:1002:51::4]",
        "valid.ipv6.addr@[IPv6:fe80::230:48ff:fe33:bc33]",
        "valid.ipv6.addr@[IPv6:fe80:0000:0000:0000:0202:b3ff:fe1e:8329]",
        "valid.ipv6v4.addr@[IPv6:aaaa:aaaa:aaaa:aaaa:aaaa:aaaa:127.0.0.1]",

        // examples from wikipedia
        "niceandsimple@example.com",
        "very.common@example.com",
        "a.little.lengthy.but.fine@dept.example.com",
        "disposable.style.email.with+symbol@example.com",
        "user@[IPv6:2001:db8:1ff::a0b:dbd0]",
        "\"much.more unusual\"@example.com",
        "\"very.unusual.@.unusual.com\"@example.com",
        "\"very.(),:;<>[]\\\".VERY.\\\"very@\\\\ \\\"very\\\".unusual\"@strange.example.com",
        "postbox@com",
        "admin@mailserver1",
        "!#$%&'*+-/=?^_`{}|~@example.org",
        "\"()<>[]:,;@\\\\\\\"!#$%&'*+-/=?^_`{}| ~.a\"@example.org",
        "\" \"@example.org",

        // examples from https://github.com/Sembiance/email-validator
        "\"\\e\\s\\c\\a\\p\\e\\d\"@sld.com",
        "\"back\\slash\"@sld.com",
        "\"escaped\\\"quote\"@sld.com",
        "\"quoted\"@sld.com",
        "\"quoted-at-sign@sld.org\"@sld.com",
        "&'*+-./=?^_{}~@other-valid-characters-in-local.net",
        "01234567890@numbers-in-local.net",
        "a@single-character-in-local.org",
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org",
        "backticksarelegit@test.com",
        "bracketed-IP-instead-of-domain@[127.0.0.1]",
        "country-code-tld@sld.rw",
        "country-code-tld@sld.uk",
        "letters-in-sld@123.com",
        "local@dash-in-sld.com",
        "local@sld.newTLD",
        "local@sub.domains.com",
        "mixed-1234-in-{+^}-local@sld.net",
        "one-character-third-level@a.example.com",
        "one-letter-sld@x.org",
        "punycode-numbers-in-tld@sld.xn--3e0b707e",
        "single-character-in-sld@x.org",
        "the-character-limit@for-each-part.of-the-domain.is-sixty-three-characters.this-is-exactly-sixty-three-characters-so-it-is-valid-blah-blah.com",
        "the-total-length@of-an-entire-address.cannot-be-longer-than-two-hundred-and-fifty-four-characters.and-this-address-is-254-characters-exactly.so-it-should-be-valid.and-im-going-to-add-some-more-words-here.to-increase-the-length-blah-blah-blah-blah-bla.org",
        "uncommon-tld@sld.mobi",
        "uncommon-tld@sld.museum",
        "uncommon-tld@sld.travel",
    ]

    static var invalidAddresses: [String] = [
        "\"asdasd@asdas.com",
        "",
        "invalid",
        "invalid@",
        "invalid @",
        "invalid@[555.666.777.888]",
        "invalid@[IPv6:123456]",
        "invalid@[127.0.0.1.]",
        "invalid@[127.0.0.1].",
        "invalid@[127.0.0.1]x",

        // examples from wikipedia
        "Abc.example.com",
        "A@b@c@example.com",
        "a\"b(c)d,e:f;g<h>i[j\\k]l@example.com",
        "just\"not\"right@example.com",
        "this is\"not\\allowed@example.com",
        "this\\ still\\\"not\\\\allowed@example.com",

        // examples from https://github.com/Sembiance/email-validator
        "! #$%`|@invalid-characters-in-local.org",
        "(),:;`|@more-invalid-characters-in-local.org",
        "* .local-starts-with-dot@sld.com",
        "<>@[]`|@even-more-invalid-characters-in-local.org",
        "@missing-local.org",
        "IP-and-port@127.0.0.1:25",
        "another-invalid-ip@127.0.0.256",
        "invalid",
        "invalid-characters-in-sld@! \"#$%(),/;<>_[]`|.org",
        "invalid-ip@127.0.0.1.26",
        "local-ends-with-dot.@sld.com",
        "missing-at-sign.net",
        "missing-sld@.com",
        "missing-tld@sld.",
        "sld-ends-with-dash@sld-.com",
        "sld-starts-with-dashsh@-sld.com",
        "the-character-limit@for-each-part.of-the-domain.is-sixty-three-characters.this-is-exactly-sixty-four-characters-so-it-is-invalid-blah-blah.com",
        "the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
        "the-total-length@of-an-entire-address.cannot-be-longer-than-two-hundred-and-fifty-four-characters.and-this-address-is-255-characters-exactly.so-it-should-be-invalid.and-im-going-to-add-some-more-words-here.to-increase-the-lenght-blah-blah-blah-blah-bl.org",
        "two..consecutive-dots@sld.com",
        "unbracketed-IP@127.0.0.1",

        // examples of real (invalid) input from real users.
        "No longer available.",
        "Moved.",
    ]
  
  static var invalidAddresseResults: [EmailValidationResult] = [
    .localPartIsQoutedBadly(String.Index(encodedOffset: 17)), //"\"asdasd@asdas.com",
    .emptyString,  //"",
    .noAtCharacterFound,  //"invalid",
    .domainIsMalformed(String.Index(encodedOffset: 8)),  //"invalid@",
    .localPartIsMalformed(String.Index(encodedOffset: 7)),  //"invalid @",
    .ipV4AddressIsMalformed(String.Index(encodedOffset: 12)),  //"invalid@[555.666.777.888]",
    .ipV6AddressIsMalformed(String.Index(encodedOffset: 20)),  //"invalid@[IPv6:123456]",
    .ipAddressIsMalformed(String.Index(encodedOffset: 18)),  //"invalid@[127.0.0.1.]",
    .domainIsMalformed(String.Index(encodedOffset: 19)),  //"invalid@[127.0.0.1].",
    .domainIsMalformed(String.Index(encodedOffset: 19)),  //"invalid@[127.0.0.1]x",

      // examples from wikipedia
    .noAtCharacterFound,  //"Abc.example.com",
    .domainIsMalformed(String.Index(encodedOffset: 3)),  //"A@b@c@example.com",
    .localPartIsMalformed(String.Index(encodedOffset: 1)),  //"a\"b(c)d,e:f;g<h>i[j\\k]l@example.com",
    .localPartIsMalformed(String.Index(encodedOffset: 4)),  //"just\"not\"right@example.com",
    .localPartIsMalformed(String.Index(encodedOffset: 4)),  //"this is\"not\\allowed@example.com",
    .localPartIsMalformed(String.Index(encodedOffset: 4)),  //"this\\ still\\\"not\\\\allowed@example.com",

      // examples from https://github.com/Sembiance/email-validator
    .localPartIsMalformed(String.Index(encodedOffset: 1)),  //"! #$%`|@invalid-characters-in-local.org",
    .localPartIsMalformed(String.Index(encodedOffset: 0)),  //"(),:;`|@more-invalid-characters-in-local.org",
    .localPartIsMalformed(String.Index(encodedOffset: 1)),  //"* .local-starts-with-dot@sld.com",
    .localPartIsMalformed(String.Index(encodedOffset: 0)),  //"<>@[]`|@even-more-invalid-characters-in-local.org",
    .localPartIsMalformed(String.Index(encodedOffset: 0)),  //"@missing-local.org",
    .domainIsMalformed(String.Index(encodedOffset: 21)),  //"IP-and-port@127.0.0.1:25",
    .domainIsMalformed(String.Index(encodedOffset: 30)),  //"another-invalid-ip@127.0.0.256",
    .noAtCharacterFound,  //"invalid",
    .domainIsMalformed(String.Index(encodedOffset: 26)),  //"invalid-characters-in-sld@! \"#$%(),/;<>_[]`|.org",
    .domainIsMalformed(String.Index(encodedOffset: 23)),  //"invalid-ip@127.0.0.1.26",
    .localPartIsMalformed(String.Index(encodedOffset: 20)),  //"local-ends-with-dot.@sld.com",
    .noAtCharacterFound,  //"missing-at-sign.net",
    .domainIsMalformed(String.Index(encodedOffset: 12)),  //"missing-sld@.com",
    .domainIsMalformed(String.Index(encodedOffset: 16)),  //"missing-tld@sld.",
    .domainIsMalformed(String.Index(encodedOffset: 23)),  //"sld-ends-with-dash@sld-.com",
    .domainIsMalformed(String.Index(encodedOffset: 23)),  //"sld-starts-with-dashsh@-sld.com",
    .domainIsMalformed(String.Index(encodedOffset: 138)),  //"the-character-limit@for-each-part.of-the-domain.is-sixty-three-characters.this-is-exactly-sixty-four-characters-so-it-is-invalid-blah-blah.com",
    .localPartIsTooLong(String.Index(encodedOffset: 68)),  //"the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net",
    .stringIsTooLong(255),  //"the-total-length@of-an-entire-address.cannot-be-longer-than-two-hundred-and-fifty-four-characters.and-this-address-is-255-characters-exactly.so-it-should-be-invalid.and-im-going-to-add-some-more-words-here.to-increase-the-lenght-blah-blah-blah-blah-bl.org",
    .localPartIsMalformed(String.Index(encodedOffset: 4)),  //"two..consecutive-dots@sld.com",
    .domainIsMalformed(String.Index(encodedOffset: 24)),  //"unbracketed-IP@127.0.0.1",

      // examples of real (invalid) input from real users.
    .localPartIsMalformed(String.Index(encodedOffset: 2)), //"No longer available.",
    .localPartIsMalformed(String.Index(encodedOffset: 6)) //  "Moved.",
  ]

    static var validInternationalAddresses: [String] = [
        "伊昭傑@郵件.商務", // Chinese
        "राम@मोहन.ईन्फो", // Hindi
        "юзер@екзампл.ком", // Ukranian
        "θσερ@εχαμπλε.ψομ", // Greek
    ]

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValidAddresses() {
        EmailValidatorTests.validAddresses.forEach({
            XCTAssertTrue(EmailValidator.validate(email: $0, allowTopLevelDomains: true), "AssertTrue Failure: \($0)")
        })
    }

    func testInvalidAddresses() {
        EmailValidatorTests.invalidAddresses.forEach({
            XCTAssertFalse(EmailValidator.validate(email: $0, allowTopLevelDomains: true), "AssertFalse Failure: \($0)")
        })
    }

    func testValidInternationalAddresses() {
        EmailValidatorTests.validInternationalAddresses.forEach({
            XCTAssertTrue(EmailValidator.validate(email: $0, allowTopLevelDomains: true, allowInternational: true), "AssertTrue Failure: \($0)")
        })
    }
  
    func testValidAddresseWithResult() {
      EmailValidatorTests.validAddresses.forEach({
        let result = EmailValidator.validateWithResult(email: $0, allowTopLevelDomains: true)
        XCTAssertEqual(result, .success, "AssertTrue Failure: \($0)")
      })
    }
  
  func testValidInternationalAddressesWithResult() {
      EmailValidatorTests.validInternationalAddresses.forEach({
        let result = EmailValidator.validateWithResult(email: $0, allowTopLevelDomains: true, allowInternational: true)
        XCTAssertEqual(result, .success, "AssertTrue Failure: \($0)")
      })
  }
  
  func testInvalidAddresseWithResult() {
    EmailValidatorTests.invalidAddresses.enumerated().forEach({
      let result = EmailValidator.validateWithResult(email: $0.element, allowTopLevelDomains: true)
      XCTAssertEqual(result, EmailValidatorTests.invalidAddresseResults[$0.offset], "AssertFalse Failure: \($0.element) in \($0.offset), \(result.errorString)")
    })
  }
  
  func testInvalidResult() {
    let result = EmailValidator.validateWithResult(email: "invalid @")
    XCTAssertEqual(result, .localPartIsMalformed(String.Index(encodedOffset: 7)))
  }
}

extension EmailValidationResult {
  var errorString: String {
    switch self {
    case .emptyString, .noAtCharacterFound, .success:
      return "\(self)"
    case .domainIsMalformed(let index):
      return "domainIsMalformed \(index.encodedOffset)"
    case .ipAddressIsMalformed(let index):
      return "ipAddressIsMalformed \(index.encodedOffset)"
    case .ipV4AddressIsMalformed(let index):
      return "ipV4AddressIsMalformed \(index.encodedOffset)"
    case .ipV6AddressIsMalformed(let index):
      return "ipV6AddressIsMalformed \(index.encodedOffset)"
    case .localPartIsMalformed(let index):
      return "localPartIsMalformed \(index.encodedOffset)"
    case .localPartIsQoutedBadly(let index):
      return "localPartIsQoutedBadly \(index.encodedOffset)"
    case .stringIsTooLong(let length):
      return "stringIsTooLong \(length)"
    case .localPartIsTooLong(let index):
      return "localPartIsTooLong \(index.encodedOffset)"
    }
  }
}
