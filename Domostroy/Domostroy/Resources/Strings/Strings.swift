// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum InfoPlist {
    /// Domostroy
    internal static let cfBundleDisplayName = L10n.tr("InfoPlist", "CFBundleDisplayName", fallback: "Domostroy")
    /// Domostroy
    internal static let cfBundleName = L10n.tr("InfoPlist", "CFBundleName", fallback: "Domostroy")
  }
  internal enum Localizable {
    internal enum Auth {
      internal enum Button {
        /// Login
        internal static let login = L10n.tr("Localizable", "Auth.Button.Login", fallback: "Login")
        /// Register
        internal static let register = L10n.tr("Localizable", "Auth.Button.Register", fallback: "Register")
      }
      internal enum CodeConfirmation {
        /// We sent the code to %@.
        internal static func sentToEmailMessage(_ p1: Any) -> String {
          return L10n.tr("Localizable", "Auth.CodeConfirmation.SentToEmailMessage", String(describing: p1), fallback: "We sent the code to %@.")
        }
        /// Enter confirmation code
        internal static let title = L10n.tr("Localizable", "Auth.CodeConfirmation.Title", fallback: "Enter confirmation code")
        internal enum Error {
          /// Failed to confirm registration
          internal static let failed = L10n.tr("Localizable", "Auth.CodeConfirmation.Error.Failed", fallback: "Failed to confirm registration")
        }
      }
      internal enum Login {
        /// Login
        internal static let title = L10n.tr("Localizable", "Auth.Login.Title", fallback: "Login")
        internal enum Button {
          /// Login
          internal static let login = L10n.tr("Localizable", "Auth.Login.Button.Login", fallback: "Login")
        }
        internal enum Error {
          /// Failed to login
          internal static let failed = L10n.tr("Localizable", "Auth.Login.Error.Failed", fallback: "Failed to login")
        }
        internal enum Placeholder {
          /// Email
          internal static let email = L10n.tr("Localizable", "Auth.Login.Placeholder.Email", fallback: "Email")
          /// Password
          internal static let password = L10n.tr("Localizable", "Auth.Login.Placeholder.Password", fallback: "Password")
        }
      }
      internal enum Register {
        /// Register
        internal static let title = L10n.tr("Localizable", "Auth.Register.Title", fallback: "Register")
        internal enum Button {
          /// Register
          internal static let register = L10n.tr("Localizable", "Auth.Register.Button.Register", fallback: "Register")
        }
        internal enum Error {
          /// Failed to register
          internal static let failed = L10n.tr("Localizable", "Auth.Register.Error.Failed", fallback: "Failed to register")
        }
        internal enum Placeholder {
          /// Email
          internal static let email = L10n.tr("Localizable", "Auth.Register.Placeholder.Email", fallback: "Email")
          /// First name
          internal static let firstName = L10n.tr("Localizable", "Auth.Register.Placeholder.FirstName", fallback: "First name")
          /// Last name (optional)
          internal static let lastName = L10n.tr("Localizable", "Auth.Register.Placeholder.LastName", fallback: "Last name (optional)")
          /// Password
          internal static let password = L10n.tr("Localizable", "Auth.Register.Placeholder.Password", fallback: "Password")
          /// Phone number
          internal static let phoneNumber = L10n.tr("Localizable", "Auth.Register.Placeholder.PhoneNumber", fallback: "Phone number")
          /// Repeat password
          internal static let repeatPassword = L10n.tr("Localizable", "Auth.Register.Placeholder.RepeatPassword", fallback: "Repeat password")
        }
      }
    }
    internal enum Common {
      /// Error
      internal static let error = L10n.tr("Localizable", "Common.Error", fallback: "Error")
      /// Success
      internal static let success = L10n.tr("Localizable", "Common.Success", fallback: "Success")
      /// Warning
      internal static let warning = L10n.tr("Localizable", "Common.Warning", fallback: "Warning")
      internal enum Button {
        /// Add photo
        internal static let addPhoto = L10n.tr("Localizable", "Common.Button.AddPhoto", fallback: "Add photo")
        /// Cancel
        internal static let cancel = L10n.tr("Localizable", "Common.Button.Cancel", fallback: "Cancel")
        /// Done
        internal static let done = L10n.tr("Localizable", "Common.Button.Done", fallback: "Done")
        /// Retry
        internal static let retry = L10n.tr("Localizable", "Common.Button.Retry", fallback: "Retry")
      }
      internal enum Placeholder {
        /// Search
        internal static let search = L10n.tr("Localizable", "Common.Placeholder.Search", fallback: "Search")
      }
    }
    internal enum CreateRequest {
      /// Request
      internal static let title = L10n.tr("Localizable", "CreateRequest.Title", fallback: "Request")
      internal enum Button {
        /// Submit
        internal static let submit = L10n.tr("Localizable", "CreateRequest.Button.Submit", fallback: "Submit")
      }
      internal enum Details {
        /// Submit
        internal static let header = L10n.tr("Localizable", "CreateRequest.Details.Header", fallback: "Submit")
      }
      internal enum Info {
        /// You will be able to contact the lessor after creating a booking.
        internal static let afterBooking = L10n.tr("Localizable", "CreateRequest.Info.AfterBooking", fallback: "You will be able to contact the lessor after creating a booking.")
        /// The lessor will receive your contact details specified in your profile.
        internal static let contactData = L10n.tr("Localizable", "CreateRequest.Info.ContactData", fallback: "The lessor will receive your contact details specified in your profile.")
        /// Communication with lessor
        internal static let header = L10n.tr("Localizable", "CreateRequest.Info.Header", fallback: "Communication with lessor")
      }
      internal enum Placeholder {
        /// Select dates
        internal static let calendar = L10n.tr("Localizable", "CreateRequest.Placeholder.Calendar", fallback: "Select dates")
      }
      internal enum TotalCost {
        /// Rental cost
        internal static let header = L10n.tr("Localizable", "CreateRequest.TotalCost.Header", fallback: "Rental cost")
        /// The amount is indicative. Payment terms to be agreed with the lessor.
        internal static let note = L10n.tr("Localizable", "CreateRequest.TotalCost.Note", fallback: "The amount is indicative. Payment terms to be agreed with the lessor.")
      }
    }
    internal enum Filter {
      /// Filters
      internal static let title = L10n.tr("Localizable", "Filter.Title", fallback: "Filters")
      internal enum Button {
        /// Apply
        internal static let apply = L10n.tr("Localizable", "Filter.Button.Apply", fallback: "Apply")
      }
      internal enum Category {
        /// Category
        internal static let header = L10n.tr("Localizable", "Filter.Category.Header", fallback: "Category")
      }
      internal enum Placeholder {
        /// Select a category
        internal static let category = L10n.tr("Localizable", "Filter.Placeholder.Category", fallback: "Select a category")
      }
    }
    internal enum Home {
      internal enum Empty {
        /// Nothing found
        internal static let message = L10n.tr("Localizable", "Home.Empty.message", fallback: "Nothing found")
      }
      internal enum Section {
        internal enum Recommended {
          /// Recommended
          internal static let title = L10n.tr("Localizable", "Home.Section.Recommended.title", fallback: "Recommended")
        }
      }
    }
    internal enum HttpError {
      /// Bad request
      internal static let badRequest = L10n.tr("Localizable", "HttpError.BadRequest", fallback: "Bad request")
      /// Forbidden
      internal static let forbidden = L10n.tr("Localizable", "HttpError.forbidden", fallback: "Forbidden")
      /// Internal server error
      internal static let internalServerError = L10n.tr("Localizable", "HttpError.InternalServerError", fallback: "Internal server error")
      /// Not found
      internal static let notFound = L10n.tr("Localizable", "HttpError.NotFound", fallback: "Not found")
      /// Unauthorized
      internal static let unauthorized = L10n.tr("Localizable", "HttpError.Unauthorized", fallback: "Unauthorized")
    }
    internal enum LessorCalendar {
      /// Dates
      internal static let title = L10n.tr("Localizable", "LessorCalendar.Title", fallback: "Dates")
      internal enum Button {
        /// Apply
        internal static let apply = L10n.tr("Localizable", "LessorCalendar.Button.Apply", fallback: "Apply")
      }
    }
    internal enum OfferDetails {
      internal enum Button {
        /// Rent
        internal static let rent = L10n.tr("Localizable", "OfferDetails.Button.Rent", fallback: "Rent")
      }
      internal enum Description {
        /// Description
        internal static let header = L10n.tr("Localizable", "OfferDetails.Description.Header", fallback: "Description")
      }
      internal enum Specifications {
        /// Specifications
        internal static let header = L10n.tr("Localizable", "OfferDetails.Specifications.Header", fallback: "Specifications")
      }
    }
    internal enum Offers {
      /// Published on %@
      internal static func publishedAt(_ p1: Any) -> String {
        return L10n.tr("Localizable", "Offers.PublishedAt", String(describing: p1), fallback: "Published on %@")
      }
      internal enum Condition {
        /// Brand new
        internal static let new = L10n.tr("Localizable", "Offers.Condition.New", fallback: "Brand new")
        /// Used
        internal static let used = L10n.tr("Localizable", "Offers.Condition.Used", fallback: "Used")
      }
      internal enum Create {
        internal enum Button {
          /// Publish
          internal static let publish = L10n.tr("Localizable", "Offers.Create.Button.Publish", fallback: "Publish")
          internal enum AvailableDates {
            /// Select available dates
            internal static let placeholder = L10n.tr("Localizable", "Offers.Create.Button.AvailableDates.Placeholder", fallback: "Select available dates")
            /// Available dates
            internal static let selected = L10n.tr("Localizable", "Offers.Create.Button.AvailableDates.Selected", fallback: "Available dates")
          }
        }
        internal enum Label {
          /// Available dates
          internal static let availableDates = L10n.tr("Localizable", "Offers.Create.Label.AvailableDates", fallback: "Available dates")
          /// Category
          internal static let category = L10n.tr("Localizable", "Offers.Create.Label.Category", fallback: "Category")
          /// Condition
          internal static let condition = L10n.tr("Localizable", "Offers.Create.Label.Condition", fallback: "Condition")
          /// Description
          internal static let description = L10n.tr("Localizable", "Offers.Create.Label.Description", fallback: "Description")
          /// Name
          internal static let name = L10n.tr("Localizable", "Offers.Create.Label.Name", fallback: "Name")
          /// Pictures
          internal static let pictures = L10n.tr("Localizable", "Offers.Create.Label.Pictures", fallback: "Pictures")
          /// Price
          internal static let price = L10n.tr("Localizable", "Offers.Create.Label.Price", fallback: "Price")
        }
        internal enum NewOffer {
          /// New offer
          internal static let title = L10n.tr("Localizable", "Offers.Create.NewOffer.Title", fallback: "New offer")
        }
        internal enum Placeholder {
          /// Select category
          internal static let category = L10n.tr("Localizable", "Offers.Create.Placeholder.Category", fallback: "Select category")
          /// Select condition
          internal static let condition = L10n.tr("Localizable", "Offers.Create.Placeholder.Condition", fallback: "Select condition")
          /// Description
          internal static let description = L10n.tr("Localizable", "Offers.Create.Placeholder.Description", fallback: "Description")
          /// Name
          internal static let name = L10n.tr("Localizable", "Offers.Create.Placeholder.Name", fallback: "Name")
          /// Price
          internal static let price = L10n.tr("Localizable", "Offers.Create.Placeholder.Price", fallback: "Price")
        }
      }
      internal enum Favorites {
        /// Favorites
        internal static let title = L10n.tr("Localizable", "Offers.Favorites.Title", fallback: "Favorites")
        internal enum Empty {
          /// You have not saved any offers yet
          internal static let message = L10n.tr("Localizable", "Offers.Favorites.Empty.Message", fallback: "You have not saved any offers yet")
        }
      }
      internal enum MyOffers {
        /// My offers
        internal static let title = L10n.tr("Localizable", "Offers.MyOffers.Title", fallback: "My offers")
        internal enum Empty {
          /// You have not posted any offers yet
          internal static let message = L10n.tr("Localizable", "Offers.MyOffers.Empty.Message", fallback: "You have not posted any offers yet")
        }
      }
    }
    internal enum Plural {
      internal enum Day {
        /// days
        internal static let few = L10n.tr("Localizable", "Plural.Day.Few", fallback: "days")
        /// days
        internal static let many = L10n.tr("Localizable", "Plural.Day.Many", fallback: "days")
        /// day
        internal static let one = L10n.tr("Localizable", "Plural.Day.One", fallback: "day")
      }
      internal enum Offer {
        /// offers
        internal static let few = L10n.tr("Localizable", "Plural.Offer.Few", fallback: "offers")
        /// offers
        internal static let many = L10n.tr("Localizable", "Plural.Offer.Many", fallback: "offers")
        /// offer
        internal static let one = L10n.tr("Localizable", "Plural.Offer.One", fallback: "offer")
      }
    }
    internal enum Profile {
      /// Profile
      internal static let title = L10n.tr("Localizable", "Profile.Title", fallback: "Profile")
      internal enum Button {
        internal enum AdminPanel {
          /// Admin panel
          internal static let title = L10n.tr("Localizable", "Profile.Button.AdminPanel.Title", fallback: "Admin panel")
        }
        internal enum Logout {
          /// Logout
          internal static let title = L10n.tr("Localizable", "Profile.Button.Logout.Title", fallback: "Logout")
        }
      }
      internal enum Unauthorized {
        /// Please login to access all features
        internal static let message = L10n.tr("Localizable", "Profile.Unauthorized.Message", fallback: "Please login to access all features")
        internal enum Button {
          /// Authorize
          internal static let authorize = L10n.tr("Localizable", "Profile.Unauthorized.Button.Authorize", fallback: "Authorize")
        }
      }
    }
    internal enum RequestCalendar {
      /// Dates
      internal static let title = L10n.tr("Localizable", "RequestCalendar.Title", fallback: "Dates")
      /// Rental cost: %@
      internal static func totalCost(_ p1: Any) -> String {
        return L10n.tr("Localizable", "RequestCalendar.TotalCost", String(describing: p1), fallback: "Rental cost: %@")
      }
      internal enum Button {
        /// Apply
        internal static let apply = L10n.tr("Localizable", "RequestCalendar.Button.Apply", fallback: "Apply")
      }
    }
    internal enum Search {
      internal enum Empty {
        /// Nothing found
        internal static let message = L10n.tr("Localizable", "Search.Empty.message", fallback: "Nothing found")
      }
      internal enum TextField {
        /// Search
        internal static let placeholder = L10n.tr("Localizable", "Search.TextField.Placeholder", fallback: "Search")
      }
    }
    internal enum Sort {
      /// Default
      internal static let `default` = L10n.tr("Localizable", "Sort.Default", fallback: "Default")
      /// Sort
      internal static let placeholder = L10n.tr("Localizable", "Sort.Placeholder", fallback: "Sort")
      /// Price ascending
      internal static let priceAscending = L10n.tr("Localizable", "Sort.PriceAscending", fallback: "Price ascending")
      /// Price descending
      internal static let priceDescending = L10n.tr("Localizable", "Sort.PriceDescending", fallback: "Price descending")
      /// Most recent
      internal static let recent = L10n.tr("Localizable", "Sort.Recent", fallback: "Most recent")
      /// Sort
      internal static let title = L10n.tr("Localizable", "Sort.Title", fallback: "Sort")
      internal enum Button {
        /// Apply
        internal static let apply = L10n.tr("Localizable", "Sort.Button.Apply", fallback: "Apply")
      }
    }
    internal enum UserProfile {
      /// On Domostroy since %@
      internal static func registrationDate(_ p1: Any) -> String {
        return L10n.tr("Localizable", "UserProfile.RegistrationDate", String(describing: p1), fallback: "On Domostroy since %@")
      }
      internal enum Section {
        internal enum Offers {
          /// No offers
          internal static let empty = L10n.tr("Localizable", "UserProfile.Section.Offers.Empty", fallback: "No offers")
        }
      }
    }
    internal enum ValidationError {
      /// Invalid email address
      internal static let email = L10n.tr("Localizable", "ValidationError.Email", fallback: "Invalid email address")
      /// Validation failed
      internal static let failed = L10n.tr("Localizable", "ValidationError.failed", fallback: "Validation failed")
      /// Incorrect format
      internal static let invalid = L10n.tr("Localizable", "ValidationError.invalid", fallback: "Incorrect format")
      /// Invalid phone number
      internal static let phone = L10n.tr("Localizable", "ValidationError.Phone", fallback: "Invalid phone number")
      /// Field is required
      internal static let `required` = L10n.tr("Localizable", "ValidationError.required", fallback: "Field is required")
      internal enum OfferDescription {
        /// Description is too long
        internal static let long = L10n.tr("Localizable", "ValidationError.OfferDescription.long", fallback: "Description is too long")
      }
      internal enum OfferName {
        /// Offer name can't be empty
        internal static let empty = L10n.tr("Localizable", "ValidationError.OfferName.empty", fallback: "Offer name can't be empty")
        /// Offer name is too long
        internal static let long = L10n.tr("Localizable", "ValidationError.OfferName.long", fallback: "Offer name is too long")
      }
      internal enum Password {
        /// Password must contain at least one capital letter
        internal static let capitalletter = L10n.tr("Localizable", "ValidationError.Password.capitalletter", fallback: "Password must contain at least one capital letter")
        /// Password contains invalid characters
        internal static let invalidSymbols = L10n.tr("Localizable", "ValidationError.Password.invalidSymbols", fallback: "Password contains invalid characters")
        /// Password mustn't be longer than 69 characters
        internal static let long = L10n.tr("Localizable", "ValidationError.Password.long", fallback: "Password mustn't be longer than 69 characters")
        /// Passwords must match
        internal static let mismatch = L10n.tr("Localizable", "ValidationError.Password.mismatch", fallback: "Passwords must match")
        /// Password must contain at least one digit
        internal static let noDigit = L10n.tr("Localizable", "ValidationError.Password.noDigit", fallback: "Password must contain at least one digit")
        /// Password must contain at least one Latin letter
        internal static let noLetter = L10n.tr("Localizable", "ValidationError.Password.noLetter", fallback: "Password must contain at least one Latin letter")
        /// Password must contain at least one number
        internal static let nonumbers = L10n.tr("Localizable", "ValidationError.Password.nonumbers", fallback: "Password must contain at least one number")
        /// Password must contain at least one special character
        internal static let noSpecialChar = L10n.tr("Localizable", "ValidationError.Password.noSpecialChar", fallback: "Password must contain at least one special character")
        /// Password must be at least 8 characters long
        internal static let short = L10n.tr("Localizable", "ValidationError.Password.short", fallback: "Password must be at least 8 characters long")
      }
      internal enum Price {
        /// Invalid price format
        internal static let invalidFormat = L10n.tr("Localizable", "ValidationError.Price.invalidFormat", fallback: "Invalid price format")
        /// Price must be a positive value
        internal static let negative = L10n.tr("Localizable", "ValidationError.Price.negative", fallback: "Price must be a positive value")
        /// Price must be less than %@
        internal static func tooHigh(_ p1: Any) -> String {
          return L10n.tr("Localizable", "ValidationError.Price.tooHigh", String(describing: p1), fallback: "Price must be less than %@")
        }
      }
      internal enum Username {
        /// Mustn't be longer than 64 characters
        internal static let long = L10n.tr("Localizable", "ValidationError.Username.long", fallback: "Mustn't be longer than 64 characters")
        /// Must be at least 2 characters long
        internal static let short = L10n.tr("Localizable", "ValidationError.Username.short", fallback: "Must be at least 2 characters long")
      }
    }
  }
  internal enum Plurals {
    /// Plural format key: "%#@VAR@"
    internal static func day(_ p1: Int) -> String {
      return L10n.tr("Plurals", "Day", p1, fallback: "Plural format key: \"%#@VAR@\"")
    }
    /// Plural format key: "%#@VAR@"
    internal static func offer(_ p1: Int) -> String {
      return L10n.tr("Plurals", "Offer", p1, fallback: "Plural format key: \"%#@VAR@\"")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
