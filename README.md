# SuperScoreboard

For all of your up to the minute football scores from around the globe.

1. ## How to set up and run the project

   - Ensure Xcode 16.4 or later is installed
   - Open the `SuperScoreboard.xcworkspace` workspace
   - Select the `SuperScoreboard` target and click run (or `CMD + R`)

2. ## Complete the task

   - Use the data already being fetched by the app to bring the provided [Figma designs](https://www.figma.com/design/hY3cElxFKc1mkl9oZ8GAi4/Test-Design?node-id=1-61823&t=IbXirDv081k0WauS-1) to life.
   - Aim to match the look and feel of the designs as closely as possible.
   - Show us your best practices when it comes to modelling data and presenting it on screen.
   - Write code that is testable, and add tests to demonstrate it.
   - You’re welcome to adjust or refactor any of the starter code if it helps your approach, it's simply there to get you started.
   - Make sure data fetching includes proper loading and error states.
   - If something about the design or data isn’t clear, make sensible assumptions—we’ll cover them in the review. Not everything is available, so be prepared to think on your feet!
   - You can bring in 3rd party frameworks if they add value, but be ready to explain your reasoning. We want you to focus on demonstrating solid engineering, not relying what other people can do.
   - Feel free to use the latest features from the OS, toolset, or language. There are no restrictions on minimum support.

3. ## Document and deliver

   - At the bottom of this README, include a short section with your notes.
   - Outline your approach, highlight any trade-offs you made, and call out assumptions around the data or designs.
   - This helps us understand your thinking and makes the review process smoother.
   - When you’re finished, share the completed project with us. You can either:
      - Push it to a public or private GitHub repository and share access, or
      - Send it as a zipped project folder.

---

## Candidate Notes

### Design Implementation
**Main goal was to replicate Figma design as close as possible** - Focused on pixel-perfect implementation of the provided designs, ensuring visual consistency across different screen sizes and states.

### Architecture & Code Quality
**Architecture Decisions: MVVM with Observable for state management** - Used SwiftUI's `@Observable` macro for reactive state management, ensuring clean separation between view models and views. Implemented proper dependency injection for services.

**Code Quality: Clean separation of concerns and maintainable structure** - Organized code into logical modules (Views, ViewModels, Services, Models), with clear naming conventions following Apple's guidelines. Created reusable components and extensions for better maintainability.

### UI/UX Implementation
**Favourites Feature**: Implemented a minimalistic approach using a modal grid interface for favourite selection, avoiding TabView to preserve the banner design. Matches with favourite teams/players appear at the top of the list with proper visual distinction.

**Responsive Design**: Used automatic padding and flexible layouts to accommodate different screen sizes. Implemented consistent spacing and typography matching the Figma designs.

**Visual Details**: Created custom TrapezoidShape with mask modifier to ensure the "face off" image stays within bounds. Implemented consistent score display with maximum frame constraints to maintain layout stability.

### Error Handling & User Experience
**Error Handling Strategy: Three-tier approach with user-friendly messaging** - Implemented comprehensive error handling with:
- Network failure recovery with exponential backoff
- User-friendly error messages with actionable recovery suggestions
- Graceful degradation with cached data display

**User Experience: Loading states, error recovery, and data validation** - Added proper loading indicators, retry functionality, and data validation to ensure robust user experience.

### Concurrency & Performance
**Did not introduce concurrency extensively** - Marked critical components with `@MainActor` for smooth UI updates. Apple warns against introducing concurrency sparingly and only when absolutely necessary. In production, data fetching and persistence would use background actors.

### Testing
**Testing Philosophy: Comprehensive coverage with modern Swift Testing** - Implemented extensive test suite covering:
- View model logic and state management
- Service layer functionality with mock implementations
- Error handling scenarios
- Data validation and edge cases

### Assumptions & Trade-offs
**Assumptions around data**: Made sensible assumptions about missing data (player photos, detailed league information) and implemented placeholder handling for production readiness.

**Shortcuts taken for speed**:
- Used team names for image assets (would be remote URLs in production)
- Coupled FavouritesService to SwiftData (would be abstracted with protocol in production)
- Limited league detail view implementation due to time constraints

### Future Enhancements
**If given more time**: Would add haptics to favourite buttons, Live Activities for match updates, and home screen widgets for favourite matches. Would also implement proper image caching and remote asset loading.

### Development Process
**Structured PRs for easy review and development tracking** - Broke down the development into logical, focused PRs that each addressed specific features or fixes. This makes it easy to:
- Follow the development process chronologically
- Review changes incrementally without overwhelming context
- Understand the reasoning behind each implementation decision
- Revert specific features if needed during development

### Key Technical Decisions
- **No 3rd party frameworks**: Focused on demonstrating solid engineering with native SwiftUI and SwiftData
- **Latest OS features**: Utilized iOS 18+ features including Swift Testing framework and modern SwiftUI patterns
- **Testability**: Designed components with dependency injection to enable comprehensive testing
- **Performance**: Implemented lazy loading and efficient data structures for smooth scrolling and state updates
