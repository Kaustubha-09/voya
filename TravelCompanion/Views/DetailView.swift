import SwiftUI
import MapKit

struct DetailView: View {
    @ObservedObject var viewModel: DetailViewModel
    @State private var selectedImageIndex = 0
    @State private var showBooking = false

    private var allImages: [String] {
        [viewModel.stay.imageURL] + viewModel.stay.additionalImages
    }

    private var reviews: [Review] {
        MockData.reviews[viewModel.stay.id] ?? []
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                imageCarousel
                contentSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 14) {
                    shareButton
                    favoriteButton
                }
            }
        }
        .safeAreaInset(edge: .bottom) { reserveBar }
        .sheet(isPresented: $showBooking) {
            BookingSheet(viewModel: BookingViewModel(stay: viewModel.stay))
        }
        .onAppear { viewModel.recordView() }
    }

    // MARK: - Image Carousel

    private var imageCarousel: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(allImages.indices, id: \.self) { i in
                AsyncCachedImage(urlString: allImages[i])
                    .tag(i)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 320)
    }

    // MARK: - Content

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleBlock
            Divider()
            hostBlock
            Divider()
            descriptionBlock
            Divider()
            amenitiesSection
            Divider()
            locationSection
            Divider()
            reviewsSection
            Color.clear.frame(height: 80)
        }
        .padding(20)
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.stay.title)
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(Color.accentRed)
                    .font(.subheadline)
                Text(viewModel.stay.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            RatingBadge(rating: viewModel.stay.rating, reviewCount: viewModel.stay.reviewCount)
        }
    }

    private var hostBlock: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.title)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Hosted by \(viewModel.stay.host)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Label("Superhost", systemImage: "rosette")
                    .font(.caption)
                    .foregroundStyle(Color.accentRed)
            }
        }
    }

    private var descriptionBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About this place")
                .font(.headline)
            Text(viewModel.stay.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
    }

    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("What this place offers")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.stay.amenities) { amenity in
                    HStack(spacing: 10) {
                        Image(systemName: amenity.icon)
                            .frame(width: 22)
                            .foregroundStyle(Color.accentRed)
                        Text(amenity.name)
                            .font(.subheadline)
                        Spacer()
                    }
                }
            }
        }
    }

    // MARK: - MapKit location preview

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Where you'll be")
                .font(.headline)

            let coord = CLLocationCoordinate2D(
                latitude: viewModel.stay.coordinates.latitude,
                longitude: viewModel.stay.coordinates.longitude
            )

            Map(initialPosition: .region(
                MKCoordinateRegion(center: coord,
                                   span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
            )) {
                Marker(viewModel.stay.location, coordinate: coord)
                    .tint(Color.accentRed)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .disabled(true)

            Text(viewModel.stay.location)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Reviews")
                    .font(.headline)
                Spacer()
                RatingBadge(rating: viewModel.stay.rating, reviewCount: viewModel.stay.reviewCount)
            }
            ForEach(reviews) { review in
                ReviewCard(review: review)
            }
        }
    }

    // MARK: - Reserve bar

    private var reserveBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.formattedPrice)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Taxes & fees included")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                showBooking = true
                HapticService.trigger(.soft)
            } label: {
                Text("Reserve")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(Color.accentRed)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }

    // MARK: - Toolbar buttons

    private var shareButton: some View {
        ShareLink(item: "Check out \(viewModel.stay.title) in \(viewModel.stay.location)!") {
            Image(systemName: "square.and.arrow.up")
                .font(.body)
        }
    }

    private var favoriteButton: some View {
        Button {
            viewModel.toggleFavorite()
            HapticService.trigger(viewModel.isFavorite ? .success : .soft)
        } label: {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(viewModel.isFavorite ? Color.accentRed : .primary)
                .font(.title3)
                .contentTransition(.symbolEffect(.replace))
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(viewModel: DetailViewModel(stay: MockData.stays[0]))
    }
}
